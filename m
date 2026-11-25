Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620646;
	b=n3CjyZCerv5NNQVqsZA54OVqabOHtmS1IUsaQqYXy9TUmfeGturr+ELD6jqBdPcGqXpU
	 ni0H1hkxdBuBzGHnCNU2HgjFMEQKTHuH2UvWsoXxdDmCjK/7fkQ+P5MQi/U2Kdv3f3AaE
	 MuDyR1p9wMewzxPY1CA1kbGooCRGWMgXs34KbgSShrMn4od9qSiPLfH6jkOVhC0o8Tits
	 CC2l9UvN1WIglAwtQhlsV/+Yf8U3vdacDwtmtOE3w8rICQx1TaFliAZ8pyblHgGhBvO8b
	 8VTM11hLsLVi3p1TY0JDhnHIF8YGZteNdlxrLuLNVHLwmgybFxQ7V47bQpfGgxGsjCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620646;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9wG780hK9Ey5wgY304MGRU4SYGIgdhkOsp80hmXYBj0=;
	b=1mvgLAzJ9aA6omXSYqgSMjjIaSzVdxH9DnmiFlorxT77sqPUQ4Ml38Wxeat3MXts4Q6H
	 pxYXgb5Qdv+YabJa/rvm6SMJu9B+PGyJd2WM3y89PMl0v9Tw7lxomc3HzthoHUwCdY+sG
	 OzCiy3/oPdvYJhLpfzzQ9oVvkm87YNpZIU70BM7uNcEXF/Fa8T8APw3OPbPQC1aCj9V7m
	 CYmxcLC0cHxIXBXQlOHxgXXxynGG7ONBPI3s6566jdb/evg0un8XvJuJ+sZ8qZzmyxm4Y
	 K6ckpAit50FclEhfHgR9axNZsi7ScJ2DYVXf+zU3NuFROklLq9MUGDpZUA8SjNY1Xsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SxRTqDJs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5369D606A323;
	Wed, 25 Nov 2026 15:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SxRTqDJs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A222F1F000CF;
	Wed, 25 Nov 2026 15:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620646;
	bh=9wG780hK9Ey5wgY304MGRU4SYGIgdhkOsp80hmXYBj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SxRTqDJss+Hs5Fi5BThTtqLsheU0Ib9CfbD5IkYRP38pqXuhKQCYnvIZDlUf1TwRx
	 Yk6rUOND8ZbG81AI0dwv3ZsfE3/AFnXc5HXmhMADEpEitQ2NdF8B684Blo/Pwvn7Ne
	 Zk6ZBYIWvXhRLIM9wgSumpVBy2kxEj8ROjhONwkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 7.3 0932/1005] usb: dwc3: trace: Restore request name assignment
Date: Wed, 25 Nov 2026 15:37:50 +0100
Message-ID: <20261125143843.516592460@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit d8090de52e0a8f1761ced4fc31d52a3e289e341c upstream.

The commit 0a06917432a7 ("usb: dwc3: Log dwc3 address in traces")
removed the __assign_str(name) call from dwc3_log_request. The name
field still exists in the trace event, but nothing fills it in, so the
endpoint name printed for these events is leftover garbage from the ring
buffer.

Put the __assign_str() call back so the endpoint name is logged again.

Fixes: 0a06917432a7 ("usb: dwc3: Log dwc3 address in traces")
Cc: stable <stable@kernel.org>
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://patch.msgid.link/8bd045b136bfef8ce5de79f1fa2f09db639f0707.1792543567.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/trace.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/dwc3/trace.h b/drivers/usb/dwc3/trace.h
index 5253da23d8b0..0caaa0b396d1 100644
--- a/drivers/usb/dwc3/trace.h
+++ b/drivers/usb/dwc3/trace.h
@@ -141,6 +141,7 @@ DECLARE_EVENT_CLASS(dwc3_log_request,
 	),
 	TP_fast_assign(
 		__entry->base_address = req->dep->dwc->xhci_resources[0].start;
+		__assign_str(name);
 		__entry->req = req;
 		__entry->actual = req->request.actual;
 		__entry->length = req->request.length;
-- 
2.56.1



