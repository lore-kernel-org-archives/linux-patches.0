Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 238B1101C1;
	Sat,  3 Feb 2024 04:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933409; cv=none; b=fIR7Yuife3Wb9BVx9gwW8xAhuuu9/tIoS4I04sBIE2Vy7R808z3rnzV6oWEpxlPCvRu44YC5MObbWM5NQFsY0M2EtDi4lHRE2Ht3Eb36y/PHTHkEmpntjcVzVolpHWpkN5hWF7TSaEcXcZNr0WQt9zV6+jxXz75sr3ReRZ7O0c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933409; c=relaxed/simple;
	bh=yFNMFvCXu9aQHJdvW6lY9cUqj21taBmExrNOzXpiev0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QgSSsrUU9wKmE+x2m50nH0g7tT65BEJX5iGNDvbbbhwnaBmLOT6RPOlGlTFLh5QngPTZXgd74E/s9E1gWQv+rxio/G9PAqoxso3XzEuHLiazU1s4mY0BzGsFIBQa2jvferVv3D47D/l5Vwjbigg7LBjpDhR9g37VYv7O855fT9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wOCh+dih; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wOCh+dih"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0CBCC433F1;
	Sat,  3 Feb 2024 04:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933409;
	bh=yFNMFvCXu9aQHJdvW6lY9cUqj21taBmExrNOzXpiev0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wOCh+dihOd5TAOijcNDdKGZaTRmqHnqMZNEttNL/p+6YEbOBw18dGdAH4wVx3h4xg
	 Vk+jVcJuubauk0yGaf5W0KBDK8r6hBE5/yVHKHFj96+6DphQgaDG16humbM5FwsVsL
	 ++rSQRGmG80u7xBpN1W9qw2ui7PSxRteHUnzC48Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 130/219] media: ddbridge: fix an error code problem in ddb_probe
Date: Fri,  2 Feb 2024 20:05:03 -0800
Message-ID: <20240203035335.777025516@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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
index 91733ab9f58c..363badab7cf0 100644
--- a/drivers/media/pci/ddbridge/ddbridge-main.c
+++ b/drivers/media/pci/ddbridge/ddbridge-main.c
@@ -238,7 +238,7 @@ static int ddb_probe(struct pci_dev *pdev,
 	ddb_unmap(dev);
 	pci_set_drvdata(pdev, NULL);
 	pci_disable_device(pdev);
-	return -1;
+	return stat;
 }
 
 /****************************************************************************/
-- 
2.43.0



