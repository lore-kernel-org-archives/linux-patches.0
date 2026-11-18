Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034559;
	b=5FFXt6VFwTvpU0CsZ32cR9iL27+2/H3V9Bmk6mLP1JpKB2PmhwZusaZWXU0IHcod75ec
	 eYeAS4B1xaEqkmljzwZRTPojpS/p9OEWQGsz+qQkviwa9EnYd6aPznBrf6pg9IJgfEnzy
	 0ORPN+QCVqh0XBiHbNxLxjLO1Zt4ouUCNfSA/lzAJlwpqfzKCjBFSr2p7Z8+616gbqsQI
	 sBVty/RIwUGn74KsFp/SIzurnRXnRa0WkU2gkF2y5bP8yTmSMI4OJJauHHQXcb2w20Ojg
	 oHj8OQS3aB3qUIfGoOljcQft8OTRbjoOm/++T4QzpLCctUn/k+H4eM7BghP3L+8nMEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034559;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NwU7+7qGYVjsP+O6oA4HjZRDHzCJXvS4Bc9BUhSJeqs=;
	b=21QUxTSoJop51nOsDQ2VSR2KeFDJVmBIY6s5CIAPRRa/fyIpbA/vO2lVv4ubx7P1nrzN
	 kZt0XaeTpH7nvIHFnFVf3LpFmfpSdb8uFs8Ld8AL3Vqfu0tHYmmmWh32OVsM0u8ZcitMD
	 kpFO9OWWeO9d1pjrtFG4chTN3P30E1CgVoQxqrZwpcneMKrItcdydFSfmdUUhePdSuiUw
	 ZnCMIfHZyPHL62BVyipuaaTfI0MCuCNlOl5be0gO3qYknyb4QOswo5UHHNSuwmuQm8pcI
	 mdZrp7OvSICAQmoIamVBBKLLJCKDH9PJnyshI8v7/cW3zKlXiLn9bMJXDC1PsiwjPXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e5DvJ+mJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A32606A320;
	Wed, 18 Nov 2026 20:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e5DvJ+mJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A7901F000C4;
	Wed, 18 Nov 2026 20:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034559;
	bh=NwU7+7qGYVjsP+O6oA4HjZRDHzCJXvS4Bc9BUhSJeqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e5DvJ+mJ6FMLUtX925qlOR7znQG2hvrJQPBnNai5TO7MccmO3TI71uRebLYwIi+7Q
	 prW2NN6jhStAVjQgJ6Toi5JngkdxUBn0Hd6GPKBDk8kCpQwiOQnFxNQ5yir6WfCjhC
	 PEhEyrB52p6i+K8/hNDTCUEeZLuSMiNWxn3+WlDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0412/3318] usb: dwc3: gadget: Fix use-after-free in dwc3_gadget_free_endpoints due to race condition
Date: Wed, 18 Nov 2026 15:17:14 +0100
Message-ID: <20261118150328.851853337@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pei Xiao <xiaopei01@kylinos.cn>

[ Upstream commit 9c855832790cd488d87de1885974f4c37cfe7358 ]

In dwc3_gadget_init_endpoint, &dep->nostream_work is bound with
dwc3_nostream_work, and dwc3_gadget_endpoint_stream_event can queue
this delayed work on system_percpu_wq when a DEPEVT_STREAM_NOSTREAM
event is received.

If we remove the gadget, dwc3_gadget_free_endpoints makes cleanup and
the memory allocated for dep with kzalloc() is released by kfree(dep),
while the delayed work mentioned above may still be pending or
running. The sequence of operations that may lead to a UAF bug is as
follows:

CPU0                                      CPU1

                                          | dwc3_thread_interrupt
                                          | dwc3_endpoint_interrupt
                                          | dwc3_gadget_endpoint_stream_event
                                          | queue_delayed_work(system_percpu_wq,
                                          |                    &dep->nostream_work)
dwc3_gadget_free_endpoints                |
dwc3_free_trb_pool(dep)                   |
list_del(&dep->endpoint.ep_list)          |
dwc3_debugfs_remove_endpoint_dir(dep)     |
kfree(dep)                                |
// dep is freed                           |
                                          | dwc3_nostream_work
                                          | // use dep (use-after-free)

Fix it by canceling the delayed work before kfree(dep) in
dwc3_gadget_free_endpoints.

Fixes: dcfe437492e2 ("usb: dwc3: gadget: Reinitiate stream for all host NoStream behavior")
Assisted-by: Codex:deepseek-v4-flash
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Cc: stable@vger.kernel.org
Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Link: https://patch.msgid.link/331d1d5133496d2b4184e05f8848adb06930a138.1785893865.git.xiaopei01@kylinos.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/gadget.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 5bd30788301bd..c85ab610bb160 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -3505,6 +3505,7 @@ static void dwc3_gadget_free_endpoints(struct dwc3 *dwc)
 		}
 
 		dwc3_debugfs_remove_endpoint_dir(dep);
+		cancel_delayed_work_sync(&dep->nostream_work);
 		kfree(dep);
 	}
 }
-- 
2.53.0



