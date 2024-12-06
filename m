Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE921494D9;
	Fri,  6 Dec 2024 14:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733495951; cv=none; b=LUU87WAUS2zhf1vyMIsYPcbUf+AF1EoDP+vyvnbKFKsMaRWQY1mAAUoFD/5G4AiNVGkJxQHrFCd0w86qoTqhpMUOS9d3JAdGTLyQPEaK53qHgmJ3y2+XVCU8Y8WzrKaRovsE6fLS4mPPbEy+YbY5Eiytdvm+4TbWUhM4dwL/Flo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733495951; c=relaxed/simple;
	bh=OknsQ+8EwzDCRd78X9bFigKtLKXCkRiZfTJTF60PMY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lJOCRYjRB3xZOZ+E/ED62deH1nQvC7/WEebrSm4nX2VvtdLGE0ay/UrR3UMTCi54DX6CitcRnnCEuLu75UPsqfYBVNAf7QTwOW83eauPVEw8UiACgJg8BY3PnDLNOU9TJVWxLn3VUyfaqGcxyaFf7BH9f4jfdQTrKyjCe0g9rc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uq1xDPdz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uq1xDPdz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78C70C4CED1;
	Fri,  6 Dec 2024 14:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733495951;
	bh=OknsQ+8EwzDCRd78X9bFigKtLKXCkRiZfTJTF60PMY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uq1xDPdzShPdIxCgQo0CzXtcLXGsK9kG4y9srnm+qO0TfTmTw1C9q9oxGTJVRAu+/
	 o17yC8sbX0BuzGaSRt5hRQYZMGthc7otW7aQuGLe969qKACsLquqCcZ3B4aKAc7eGQ
	 1AmWI3GrlXxPj3ZJlAJnO3fS9YqJ/3sW49/bOs7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Jiri Slaby <jirislaby@kernel.org>
Subject: [PATCH 6.12 010/146] iommu/tegra241-cmdqv: Fix unused variable warning
Date: Fri,  6 Dec 2024 15:35:41 +0100
Message-ID: <20241206143528.066214570@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will@kernel.org>

commit 5492f0c4085a8fb8820ff974f17b83a7d6dab5a5 upstream.

While testing some io-pgtable changes, I ran into a compiler warning
from the Tegra CMDQ driver:

  drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c:803:23: warning: unused variable 'cmdqv_debugfs_dir' [-Wunused-variable]
    803 | static struct dentry *cmdqv_debugfs_dir;
        |                       ^~~~~~~~~~~~~~~~~
  1 warning generated.

Guard the variable declaration with CONFIG_IOMMU_DEBUGFS to silence the
warning.

Signed-off-by: Will Deacon <will@kernel.org>
Cc: Jiri Slaby <jirislaby@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
+++ b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
@@ -801,7 +801,9 @@ out_fallback:
 	return 0;
 }
 
+#ifdef CONFIG_IOMMU_DEBUGFS
 static struct dentry *cmdqv_debugfs_dir;
+#endif
 
 static struct arm_smmu_device *
 __tegra241_cmdqv_probe(struct arm_smmu_device *smmu, struct resource *res,


