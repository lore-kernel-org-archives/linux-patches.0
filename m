Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 765CC188003;
	Tue, 30 Jul 2024 17:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359462; cv=none; b=t6Qz7/CgqAocSib/TyLuYY2JWGghH2uyHfY5UIXRGW4EULyHv3GdPl/uOa5+t0ZXYYbarSNHzW3fy2GPt5l7e903zu/u0gY9KDjyXMTjvPhjYjRgE8jZetRHcZofaXuxM14ANNaJJ7y5Do4w0jNF9owDtd4cu1QoHcvx6A77tFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359462; c=relaxed/simple;
	bh=C1mW+Lj/0+47EwnnyMJqTivBpjRLDuiNjXb9ySn0i+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uvF69qSO9TlkcsKZodsfYyug6dAbm6/o+T19R2r4LXWHhkT3Hd4xiB3INHrhkHS0FT3xOU55WW9IbbI9shZZUu4YNIvZbjjVAMkcnSdyB8b1/RuoZIn4GlYnBa+UU+jItoMS16yreRELKhGMr/wC8QzuCgHmq/SsAcptKy+zS44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A+0dlOLS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A+0dlOLS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A609C32782;
	Tue, 30 Jul 2024 17:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359462;
	bh=C1mW+Lj/0+47EwnnyMJqTivBpjRLDuiNjXb9ySn0i+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A+0dlOLSGoRFvPj6Y4iRNpvgIfevkIm3wrUHzQRYnQBEdbfL+hFt181l0hHP5Tdjo
	 CiqTro2jKPmRRFZJLrEXbOD3/IME1WwMZOuxI+76Ws3tAGDGUpW4z6xMwY5p8YcN18
	 TEAqRuYcy8pUH48v8X54r2ZxiCpxK2GzL9eBXEsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.6 485/568] platform: mips: cpu_hwmon: Disable driver on unsupported hardware
Date: Tue, 30 Jul 2024 17:49:52 +0200
Message-ID: <20240730151658.984946079@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


