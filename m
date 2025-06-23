Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E333B28EA;
	Mon, 23 Jun 2025 22:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716005; cv=none; b=Ur2BJ4GZOb3oLzUYIsratiRjEl0shwAdtBqzOemYzvNZ2oEb4VYgP4Jiu4VPOhrk/+ONAMiiO8bYBQP5HDzi4p7s6Rtp0k70sV76BI7kSVoqpp7G0Z06ru3CrzHmSQ0bN88oxKlgx9+Gnxr0JmnlFH5Pe1//TbuDSWaq0jLGr2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716005; c=relaxed/simple;
	bh=DH4vLjwxisBURJVDlrAvUFC0xQt4RmJ3dgt94fItDyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K3E7R8IuN2gSRYAmzSnN1pqrGEFdGis59+dc+inMgaH9eyqofTFRMcpGFn0TgVcP6iXDwMz9uvMpl+OS7F25KSnPu9pIPS1wqaW2HToMxvz3xYdGf9PH3vfZwUTSaxNwindpd/YPmy8Iugx9OmIXSgktniXxeoqHSSQxn8lmGL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CpYCUgFK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CpYCUgFK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A8DCC4CEEA;
	Mon, 23 Jun 2025 22:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716004;
	bh=DH4vLjwxisBURJVDlrAvUFC0xQt4RmJ3dgt94fItDyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CpYCUgFKMB2Sl8s879mqQYdi7IQxE1F4ZBtoSI6UHtGXf/Rda7q51niGHHB/NzMjJ
	 isk21z6dxcrHLxD+jm1KhWNNBwjb5SsKuc4pBu1rRpP+Gyd5xh1yyJijFAxWzAQTSC
	 EUjBHjksm4+NNtsBwgvIO2+VWb/Z4aB8s2Zh3QFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aditya Garg <gargaditya08@live.com>,
	Alyssa Rosenzweig <alyssa@rosenzweig.io>
Subject: [PATCH 6.15 496/592] drm/appletbdrm: Make appletbdrm depend on X86
Date: Mon, 23 Jun 2025 15:07:34 +0200
Message-ID: <20250623130712.231194395@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aditya Garg <gargaditya08@live.com>

commit de5fbbe1531f645c8b56098be8d1faf31e46f7f0 upstream.

The appletbdrm driver is exclusively for Touch Bars on x86 Intel Macs.
The M1 Macs have a separate driver. So, lets avoid compiling it for
other architectures.

Signed-off-by: Aditya Garg <gargaditya08@live.com>
Reviewed-by: Alyssa Rosenzweig <alyssa@rosenzweig.io>
Link: https://lore.kernel.org/r/PN3PR01MB95970778982F28E4A3751392B8B72@PN3PR01MB9597.INDPRD01.PROD.OUTLOOK.COM
Signed-off-by: Alyssa Rosenzweig <alyssa@rosenzweig.io>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/tiny/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/tiny/Kconfig
+++ b/drivers/gpu/drm/tiny/Kconfig
@@ -3,6 +3,7 @@
 config DRM_APPLETBDRM
 	tristate "DRM support for Apple Touch Bars"
 	depends on DRM && USB && MMU
+	depends on X86 || COMPILE_TEST
 	select DRM_GEM_SHMEM_HELPER
 	select DRM_KMS_HELPER
 	help


