Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5343218C02E;
	Tue, 10 Sep 2024 10:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964329; cv=none; b=Ef1ajFVJHYVp0nYjBiSulUiHpoPqfz2eQbXcOrzsgJvOp//LNuhpqcsrY/8oG86pbw3M+6f4VRrlcBnhgWSCQLRYHgoey3cZ5r/cqXE8K/DWQPYkgtl8DXxqJjPy2tzK7eFWxcotccPK8eHJCltvvcXjN5uw78cf7kosScZOWSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964329; c=relaxed/simple;
	bh=msFcGLYU0PmHQS9xb3g8gTW2DZmm+OFoghLKIVIDlLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AHxYJbjiFNezMNTMZONgXr1ro0lG49idVuTQ/vo9R8TcpcSXJRLu4nEjUW+GvZ8LPfT1jEv4lvqk2YrSqdFJOAcXtECYozcGiKGGS/3zpKr2z0xwLOVhwLZ/MBY34nQ77uQ4KlgDXqeiWMnaApjLpcn3jcrR8Dxj36HQ73Z686Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gtu0evWV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gtu0evWV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFEF2C4CEC3;
	Tue, 10 Sep 2024 10:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964329;
	bh=msFcGLYU0PmHQS9xb3g8gTW2DZmm+OFoghLKIVIDlLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gtu0evWVu9jGKv4NVyaZVtshHi3lTojVTN6LBAxqMypfCrf8bo/S92RAdiUoID7mz
	 kynZFtlL+kXsPGEeYBuEYBpO1csmU/rRK9ghFqReYGhupom+LGo9M8IJBrIpaDYdwH
	 ahaquS/KwhynKO2jABC/4+IaNno79bTbIrixsFBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 145/269] devres: Initialize an uninitialized struct member
Date: Tue, 10 Sep 2024 11:32:12 +0200
Message-ID: <20240910092613.381167610@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

From: Zijun Hu <quic_zijuhu@quicinc.com>

[ Upstream commit 56a20ad349b5c51909cf8810f7c79b288864ad33 ]

Initialize an uninitialized struct member for driver API
devres_open_group().

Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/1719931914-19035-4-git-send-email-quic_zijuhu@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/devres.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/base/devres.c b/drivers/base/devres.c
index 8d709dbd4e0c..e9b0d94aeabd 100644
--- a/drivers/base/devres.c
+++ b/drivers/base/devres.c
@@ -567,6 +567,7 @@ void * devres_open_group(struct device *dev, void *id, gfp_t gfp)
 	grp->id = grp;
 	if (id)
 		grp->id = id;
+	grp->color = 0;
 
 	spin_lock_irqsave(&dev->devres_lock, flags);
 	add_dr(dev, &grp->node[0]);
-- 
2.43.0



