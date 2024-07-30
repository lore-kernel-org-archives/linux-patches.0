Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D4D1A76B2;
	Tue, 30 Jul 2024 17:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360486; cv=none; b=qhswWP36WcKTze1y3c3qXHg5rlpDo3LIq1tnFsfYIQSzed/9cgHIqsOrvgkKjp606KpvCaED8segpbRrVaMj7VhdraVwjZhtGpoi5Ad89GJX0yZxQtj/vUrzNqWUbjyMUp18wzshih0ycetqZ5G6rDYev4ce8BTW8+l3C1xgSHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360486; c=relaxed/simple;
	bh=y7JHbMFn0veQ6VrSyRMyQ+cjXr7VUEOuIwxL8vdh7RI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VNacW1qj2YQ3BMlZYBtHlSejlIuuZGJXs9LDrimPTPrsOntbvUziXuq9FsT/o3Rsnj1uRvbP19kdQs8xOPuAkDcf35eLEOlUPvnGu77Dv/TrRs1ppWVZmxXpgUZwIP+0hNJsqZ52OXgnrAI9ofKGzG7csZ2H9w1ahrhC8D/ajkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EM5AfXmT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EM5AfXmT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2992C32782;
	Tue, 30 Jul 2024 17:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360486;
	bh=y7JHbMFn0veQ6VrSyRMyQ+cjXr7VUEOuIwxL8vdh7RI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EM5AfXmTPTD3yR0PEk4MRp78tKFOr7mOR+wJpfFMfA96eOm5w58t5ok8aRCV3+hZJ
	 8a7q9NsISJEpEQOLabmw3X9IOFkJlKoHSu8JMOkI8Gys63VlxXxUTqLyUTkN0Zl1Y8
	 GCtvGklEIpV1QhF3pgLhN0mGuWvMYIJghohyEAWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.10 713/809] platform: mips: cpu_hwmon: Disable driver on unsupported hardware
Date: Tue, 30 Jul 2024 17:49:49 +0200
Message-ID: <20240730151753.096256006@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiaxun Yang <jiaxun.yang@flygoat.com>

commit f4d430db17b4ef4e9c3c352a04b2fe3c93011978 upstream.

cpu_hwmon is unsupported on CPUs without loongson_chiptemp
register and csr.

Cc: stable@vger.kernel.org
Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/mips/cpu_hwmon.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/platform/mips/cpu_hwmon.c
+++ b/drivers/platform/mips/cpu_hwmon.c
@@ -139,6 +139,9 @@ static int __init loongson_hwmon_init(vo
 		csr_temp_enable = csr_readl(LOONGSON_CSR_FEATURES) &
 				  LOONGSON_CSRF_TEMP;
 
+	if (!csr_temp_enable && !loongson_chiptemp[0])
+		return -ENODEV;
+
 	nr_packages = loongson_sysconf.nr_cpus /
 		loongson_sysconf.cores_per_package;
 


