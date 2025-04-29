Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E06C21DF73C;
	Tue, 29 Apr 2025 17:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946323; cv=none; b=CzFujXwc96DgL+AieeQ7yhKhkCHYjEntO6RsEzdUwcMmx5HKfk2N5/YIhRAGIequnNbuOR6YvVMEuaRUe1qfLZ2zlMdWqUxR/30xs3eOT0x7ji+j2rRBrkJiovTTCjy7n5kOEPuQF5BNir1zIrL5L5n0a1awmh/PvfPWtSo0Qr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946323; c=relaxed/simple;
	bh=5+xGiaxdk1Gphv/ZyHUKhYVZ0q3pK9TZ60X9GPSGRe0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EqkK47lkPmkTC2cJ5ihAb3mTSphQBEPs7zLUtw9G+2yIxjkUiDlNdW6hs8pafDzUU6xd2hevV1KoeqFfSJcZ+ZiswiogeCM0UKgrgw+2bLZow2aNXBmM7cmsQHNmILACtsa4FPqTdJ+cAaK+u+uFRLinK/xjG6Mfvo1aNAPlXeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c6XXjvSx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c6XXjvSx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55483C4CEE3;
	Tue, 29 Apr 2025 17:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946322;
	bh=5+xGiaxdk1Gphv/ZyHUKhYVZ0q3pK9TZ60X9GPSGRe0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c6XXjvSxZ6s5e7EKEzhkkVjmsVX8TP3ggx3PAwwVFrtfLgUBxF710RFlLT+4kBr4f
	 SJmbMHKNRbAY8vnOY7THa7+oXxSuEjTVYwSRtcqKN9DCJbbOEnRpV6HEe2nizINpr+
	 a5SJCsGUYbJhg6XN91UYD1SvOWLO0yymy63NbRNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
	Jon Mason <jdmason@kudzu.us>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 229/311] ntb_hw_amd: Add NTB PCI ID for new gen CPU
Date: Tue, 29 Apr 2025 18:41:06 +0200
Message-ID: <20250429161130.413505259@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Basavaraj Natikar <Basavaraj.Natikar@amd.com>

[ Upstream commit bf8a7ce7e4c7267a6f5f2b2023cfc459b330b25e ]

Add NTB support for new generation of processor.

Signed-off-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Signed-off-by: Jon Mason <jdmason@kudzu.us>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ntb/hw/amd/ntb_hw_amd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ntb/hw/amd/ntb_hw_amd.c b/drivers/ntb/hw/amd/ntb_hw_amd.c
index d687e8c2cc78d..63ceed89b62ef 100644
--- a/drivers/ntb/hw/amd/ntb_hw_amd.c
+++ b/drivers/ntb/hw/amd/ntb_hw_amd.c
@@ -1318,6 +1318,7 @@ static const struct pci_device_id amd_ntb_pci_tbl[] = {
 	{ PCI_VDEVICE(AMD, 0x148b), (kernel_ulong_t)&dev_data[1] },
 	{ PCI_VDEVICE(AMD, 0x14c0), (kernel_ulong_t)&dev_data[1] },
 	{ PCI_VDEVICE(AMD, 0x14c3), (kernel_ulong_t)&dev_data[1] },
+	{ PCI_VDEVICE(AMD, 0x155a), (kernel_ulong_t)&dev_data[1] },
 	{ PCI_VDEVICE(HYGON, 0x145b), (kernel_ulong_t)&dev_data[0] },
 	{ 0, }
 };
-- 
2.39.5



