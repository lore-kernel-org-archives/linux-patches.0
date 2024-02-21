Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7B8D2A1D7;
	Wed, 21 Feb 2024 13:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522676; cv=none; b=i58QmeF1V7FpgJIL7Afz6SGAPh+8vpKCwC5s6xjGwB8LxxpP2PGb8koS8vpyyJW8AmfaPZawedyEzAWQPUHLsB79jdb+EJVEjjCq72Hn83nRupi/VgtYeaagS2zVJ5HPE+ChfSYZaJ2S4Dh/vjyU295VoutybXJY56UpYEIVVvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522676; c=relaxed/simple;
	bh=yQM3/mhiCDAUgk7cd2lb8OsqYUH7aeKOlaqz1deMjiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kajkYnYckAmsejIxzg6zp9MaCHD6zS9GjSx5bkoNcsaH66bbwY/YonWpoBU8vxWR/vqoMUHZmSDgZcOaYb6qajwZRjxZBRwzLCftbu7ktZN2W5fLdryNXBR3LUdD0mNnlmRqJRguMdTGzTQEoK+6HpzuiGPnjSJLcJ+FPedDB+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LwltRqmN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LwltRqmN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 786E7C433F1;
	Wed, 21 Feb 2024 13:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522675;
	bh=yQM3/mhiCDAUgk7cd2lb8OsqYUH7aeKOlaqz1deMjiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LwltRqmNr70I6Ff51WSgPoGY2N6qJ0jIgZlwThfLehJ+UzgpxXILdxPaIyimFgReQ
	 5XY4e2n1AFQ830DEvC+Jjnl8POp/EbXMVvUKLElAabQml5uR+GFsRWgm8xGqVnD+4R
	 UOxHX8dfffDC7P3tTweVtYV4lFJa5iNUXakGhhqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 227/476] media: ddbridge: fix an error code problem in ddb_probe
Date: Wed, 21 Feb 2024 14:04:38 +0100
Message-ID: <20240221130016.267621530@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 03dc9924fa2c..bb7fb6402d6e 100644
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



