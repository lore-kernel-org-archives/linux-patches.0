Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AA8115B31B;
	Mon, 29 Jan 2024 17:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548121; cv=none; b=Y2uibKpLNs0/2QEqpQjDQtKV4eYRxL3eJQGBE13nTN0XLdEV3cq+DKmZ1NO4BsXmRMu0faqygRKHyJM8n2xnZfAx5pZwIe0s2WxHAOWIGJ+R2fEOtYNQJxRIPnZrrPiMwMlvyC2yd22uV7ecS8lyPJf3wL7l1j7TzV5m/NjKP5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548121; c=relaxed/simple;
	bh=DqaV+aNWGh8sUOK+R4muONotz24h5iqnX9LADEojzdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WKFTJan+nFYzhF7XEryIdStnQj5FZNybccDHSxXdgndFrZQYhVtCSVEKQ81Zdbu2AMCmZQ3qzzXnUvgIiwusjMoF6zeSanveLarraj8icO2OXzP9NY0tPcUeAt4RuMwchl4Rm8w/6i47Io0qGg3GSGky8481v63QLn1gqpo1Gl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oBTh2c44; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oBTh2c44"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52F35C433C7;
	Mon, 29 Jan 2024 17:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548121;
	bh=DqaV+aNWGh8sUOK+R4muONotz24h5iqnX9LADEojzdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oBTh2c442kER5VAWHflS5eo17npd2CziITTC/9ewcIKR6IChSfYwcphSz2S4DkJTO
	 KjA0E22kSF8c7EVJ89+LIJJ94ukfvY/az2wGdp2hM3H8IA6Nog+SRjx2PLJvfYA96J
	 VpGNGtT3LTWPWOrdCNoseuqYYjwsKD4A87Vf81XY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Gray <jsg@jsg.id.au>
Subject: [PATCH 6.7 140/346] Revert "drm/amd: Enable PCIe PME from D3"
Date: Mon, 29 Jan 2024 09:02:51 -0800
Message-ID: <20240129170020.516615579@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Gray <jsg@jsg.id.au>

This reverts commit 05f7a3475af0faa8bf77f8637c4a40349db4f78f.

duplicated a change made in 6.7
6967741d26c87300a51b5e50d4acd104bc1a9759

Cc: stable@vger.kernel.org # 6.7
Signed-off-by: Jonathan Gray <jsg@jsg.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -2265,8 +2265,6 @@ retry_init:
 
 		pci_wake_from_d3(pdev, TRUE);
 
-		pci_wake_from_d3(pdev, TRUE);
-
 		/*
 		 * For runpm implemented via BACO, PMFW will handle the
 		 * timing for BACO in and out:


