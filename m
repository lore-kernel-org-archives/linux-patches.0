Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F2914831F;
	Tue, 30 Jul 2024 16:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358184; cv=none; b=rnYhB5SxvfniwSddAAzlKx68sVT/MqFXBL7gYAP5v1drw20wF0qXZQYmaOOz3YwuP+ff8aF0Ff8Mcmcj3o+tGT6Bzbp79NBro9gxSj2ejdCVTCCYaG+yYMp0/AUpYQpK0yWIKAi9zweU3afb4Lu6RUFjqwKPAF9VGFvCxpd7Qy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358184; c=relaxed/simple;
	bh=fscWf5ytAIhxqy83DqeONnLOAD7DwtHl4bdk7uNDbQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OnStNbxUsOoRmzJWH39+/20DGS9I4I97Y2VSUo9X9JzXzFruODuOkwmGhgyn+ANVLeDa+4GD9htWUsym1dOOSxL7TFp4GDN5ixeA5PTmnMvAJIyEC76qPqw9MLJ6tBnGoqVbhoWc3ZY2k211fjEHgv/KlmQ0iBSKUDjLjmM85Mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=onRxiQVC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="onRxiQVC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41EFDC4AF0A;
	Tue, 30 Jul 2024 16:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358184;
	bh=fscWf5ytAIhxqy83DqeONnLOAD7DwtHl4bdk7uNDbQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=onRxiQVCnAm/Zp738XeL3S2dIHbiQBOW5mwiRWCdaJn4Gb5pXNOhuv3mJUww2BOU2
	 lqjtwQriqErEBzzgpERbUHf8Qe40s7VDbX0bZJ13enieWGbokWWtj7Sgala2psMeRV
	 0k5mCFLvfEIx+uZKwCIevbYM+buPMF66LZXT9ZW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.1 364/440] platform: mips: cpu_hwmon: Disable driver on unsupported hardware
Date: Tue, 30 Jul 2024 17:49:57 +0200
Message-ID: <20240730151630.034596213@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 


