Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DD317D3E0;
	Mon,  8 Apr 2024 13:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582959; cv=none; b=GVjMdsSkrL7qopa2yFXjmns14ZkDZwkRbwKtu1H07fPD4PHGlqCADkaivhA2QKN75MQ72gwU7s/szu/l3LU+l34WxQqL3LwUJnqi68ZbEKb3siQENqzShOFZaXAJfUrmaHoZFoCgCFaUNbdotAWXB7Pxtfdo8KXoQ6HpeKz1UR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582959; c=relaxed/simple;
	bh=amTwSMTTKFcZDW6/YrT8jV3bJttj+MupJLFCD6bZw9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZOiEFzrh2gAGSB0WOjNeu7QANZskJNzpLtmcposlloLgWJkQ+CjzM7In81IAKGsfKU3LS4eMGsLcwanROPlS7t4m/W3EPNtVl185FexwWWLqRDcvvkEydOxjfmqcNjUS2qeADGafF8GYGi9bJovwP2ic7XK51VbodPZ6H1SSpZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mMTEHrpN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mMTEHrpN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 992CEC433F1;
	Mon,  8 Apr 2024 13:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582959;
	bh=amTwSMTTKFcZDW6/YrT8jV3bJttj+MupJLFCD6bZw9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mMTEHrpNhFTBcFyK8uXaMMnWjvFn7T7HjZUAmA6QbYWEfEMNrqKZ6mZP6jebKfNep
	 jsCBH2n996UD5HsW0V5wJA6s0mLkhi1uZ/q8esE+zFl7Q+APVqoJP2j0538o+dIwz7
	 uXWa5axnQGfbNYfjeWZ489/ePhEH+XK8i1oUJx1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.8 125/273] octeontx2-pf: check negative error code in otx2_open()
Date: Mon,  8 Apr 2024 14:56:40 +0200
Message-ID: <20240408125313.176961267@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Su Hui <suhui@nfschina.com>

commit e709acbd84fb6ef32736331b0147f027a3ef4c20 upstream.

otx2_rxtx_enable() return negative error code such as -EIO,
check -EIO rather than EIO to fix this problem.

Fixes: c926252205c4 ("octeontx2-pf: Disable packet I/O for graceful exit")
Signed-off-by: Su Hui <suhui@nfschina.com>
Reviewed-by: Subbaraya Sundeep <sbhatta@marvell.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Link: https://lore.kernel.org/r/20240328020620.4054692-1-suhui@nfschina.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1933,7 +1933,7 @@ int otx2_open(struct net_device *netdev)
 	 * mcam entries are enabled to receive the packets. Hence disable the
 	 * packet I/O.
 	 */
-	if (err == EIO)
+	if (err == -EIO)
 		goto err_disable_rxtx;
 	else if (err)
 		goto err_tx_stop_queues;


