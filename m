Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E42046B9B;
	Wed, 21 Feb 2024 13:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521491; cv=none; b=EI+0VlpQRFMEjZh+o67W4LML/xAZ+2vigbX8PZVuzxCUXHExg788b+OfjPFpGfTiELZNBsqCdPdkuFo3KFiqlsAkksh1tFaBuw7XwxAMHFIJLrX8P8amPvYxxETwh1jAwT/tkJb4UpIhkqkGOfPmZ1hvZ13qSCEYtq91MdtLHd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521491; c=relaxed/simple;
	bh=OedKXTWjV0yh31ZqHXHqBOnyS+23wM9NXdlT0vvhGOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OKdFTVD7a/oGiXTUNQL+YbIlngAeHYKhOTijCEEd+WT4D4Hwnu7cd6yWlR/OQ6+z1sANWDX1/U4/8H4fPEcrPBqDvU36feI84GKxsJ76KwuHxzeTf+lttp+7ERN5etraUg/4vNtIHs4fT/zsucvlS1Q+A1Nbqzd9tGQZXVl7gLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kframvVo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kframvVo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F021C433F1;
	Wed, 21 Feb 2024 13:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521491;
	bh=OedKXTWjV0yh31ZqHXHqBOnyS+23wM9NXdlT0vvhGOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kframvVohNV9YaQH1oEVc+1pIdzm7Jo/lASMhQ005UrZDF9ca0aLuDUNtixNmzfuJ
	 eOkxf+7XU375e8c7zX+KeAypmUI0JdDanb9WaLkJThRLZcXaaYR1eSTz0jjylgZEii
	 ZjyobpymudeGmaxJr/0RDaQCukwbW6NF0ejEToaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 109/202] media: ddbridge: fix an error code problem in ddb_probe
Date: Wed, 21 Feb 2024 14:06:50 +0100
Message-ID: <20240221125935.272172723@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Su Hui <suhui@nfschina.com>

[ Upstream commit 09b4195021be69af1e1936cca995712a6d0f2562 ]

Error code is assigned to 'stat', return 'stat' rather than '-1'.

Signed-off-by: Su Hui <suhui@nfschina.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/ddbridge/ddbridge-main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-main.c b/drivers/media/pci/ddbridge/ddbridge-main.c
index f4748cfd904b..7aa6c966ba0d 100644
--- a/drivers/media/pci/ddbridge/ddbridge-main.c
+++ b/drivers/media/pci/ddbridge/ddbridge-main.c
@@ -247,7 +247,7 @@ static int ddb_probe(struct pci_dev *pdev,
 	ddb_unmap(dev);
 	pci_set_drvdata(pdev, NULL);
 	pci_disable_device(pdev);
-	return -1;
+	return stat;
 }
 
 /****************************************************************************/
-- 
2.43.0



