Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043646;
	b=mUUr3g8GyXr9XS8CsCPotyzZADRP6teGagVr2GrUMXEb8HGMDd9wq1cdiNWDRUhVIB2U
	 XV5TYcMh1LubaBFfz5JnA39rj+EPY0KTG6e+PWKHxZoLeMQynCUa9sUtC07dTLiIR9l88
	 99rcZFAA2AsHQrPPPE3kHlnn5I+qLRupXdjM4le6PF+xycfjWe3J1rKGfx37+sWwRSaBs
	 cggbnpkbyDB+rNWYyJKJG1XqTj8db9evqGraYQGuwFKDXfNCnCWHYzU4IBlG6bJhygdZk
	 D/tFkGBIsOil4IqbZbNwjrI+5TxF/8LGqEuvbDlmxie/b4Hs9LhZf7nUFFwHTmPgsuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043646;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ziZV/uqvPxMjWD14+rDD+rJ/gN9QcQSLdXdLqWz8IXY=;
	b=WnK2V4sJ+x2J6d7gl4/rrWhrnlIsCVIkuKCFYzpjegFl6q8u5vjG1TNXxVbJDFfDDTrM
	 LTV4cUJL1KMr991JrExCCy6fcNxWylnFDxGsFMjC+YtcHbIKVjytl5TusRZQ2tUsXFae6
	 GTA1ljQ/pu/42BcT6v78fpGGhZcmUjGguSQ01nVhJom4NRs+1YljTnKVqPBj+Oq51bikg
	 QRHt5qeBp45wc5peBmwj0fVK2EkWiYAqvW05C9LvgTFUn3HxfOm7SAL2O+glmtu58UTxP
	 5P6EqQAntfq1oAnrTWsCBblWiD6AvGxcf3je/+QUS0uJzGEK9/cUNODiBrwubasqwxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oN2fseK7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A5F606A320;
	Wed, 18 Nov 2026 23:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oN2fseK7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65D091F000C4;
	Wed, 18 Nov 2026 23:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043645;
	bh=ziZV/uqvPxMjWD14+rDD+rJ/gN9QcQSLdXdLqWz8IXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oN2fseK7EHs7IzP7a937oB6Vi0ozesyDmgZmzjKkxTRCMDZTcerHlRAxolexfPPHs
	 28INrPz46x2x26jxJ7gXxvxxArj5zLxYfyHlxOLMENcrPPP9oEbqmn1l5gE96yj6Yq
	 IB7oMazuyjYbY8l0Q0mia1nBbKezVkceeu7q09WA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Daniel Wagner <dwagner@suse.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0285/2857] nvme-fc: do not warn on controller removal race
Date: Wed, 18 Nov 2026 15:21:59 +0100
Message-ID: <20261118150211.686274872@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit 62b70e6c87121ae5b79ca20c3a5b005590336ec5 ]

In nvme_fc_reconnect_or_delete(), the system attempts to remove
the controller when reconnect limits are reached by calling
nvme_delete_ctrl(). This call is currently wrapped in a WARN_ON().

If a user concurrently deletes the controller via sysfs, the
controller's state may have already transitioned out of the
CONNECTING state. When this happens, nvme_delete_ctrl() correctly
rejects the operation and returns -EBUSY. Because of the WARN_ON()
wrapper, this race condition triggers an unnecessary kernel warning
stack trace.

Remove the WARN_ON() macro around nvme_delete_ctrl();
this allows the system to safely ignore the -EBUSY return value
if the controller is already being deleted.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Reviewed-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/fc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index 914e480408553..d18b2dae1ba8c 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -3332,7 +3332,7 @@ nvme_fc_reconnect_or_delete(struct nvme_fc_ctrl *ctrl, int status)
 				ctrl->cnum, min_t(int, portptr->dev_loss_tmo,
 					(ctrl->ctrl.opts->max_reconnects *
 					 ctrl->ctrl.opts->reconnect_delay)));
-		WARN_ON(nvme_delete_ctrl(&ctrl->ctrl));
+		nvme_delete_ctrl(&ctrl->ctrl);
 	}
 }
 
-- 
2.53.0



