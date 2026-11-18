Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057886;
	b=GR8d94erf9L06RuHPPeMa3/N2iAVUnGo6SB6k2twfj/f65yKUj9lfLpuP7MHwgMaq+4K
	 ph7e1UViV/5p817nBCOfeSwrmdqSiwih+qPYFybQt6J6DTGqbr+EqAMHaO+U/eEG32vX7
	 VslkvzCcV83LRl155t15hc8Qz/o3PlxPYLKqFo5Dp1pDXxmLGy15yMsGKRg6X3Cg0Mbq5
	 KikIbPDPV1CfJ/caAsqyybcze9/qyKPDOqBACWwT95Oe2qI+nE+aBcNoPK0y6yLChINPm
	 6z0FkHdFuhvV3mzJc0thfL2MQABzzjZhJD6rLXtwtxMs8KMT+bRq0yPJPlkcWIzY1+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057886;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1jWGACESAuCpQ+LoYUM5hxHRR80QyOGp3w96rqZfhug=;
	b=zEpZdAa/UFVswpfqXjV8oT0afSRN7msJondp9q1ZbBqPWQtVDosQ61tnfnqIsNpylh3/
	 o4C+lAe/PdeUziBtv0eX2FNpaus/mt5xjMbRQ+UI77Bt9VMpBe+BTvywEkPD8DelUrkW8
	 zRKEKtaHP3EnH/J4IY0lpcRyzg5fcSTrs/vkIkF7MfUCABzezfW8Tw1skv385OJxSzyLI
	 fs2iqO/Noj8rbKKJ+Py0JYipQF2Nh4z5X6DhL5CTGuwOP9Md6Q4tI9iW0ZslPV//cG1Yt
	 WfLmYugQRBRGvqG1Gpu6QRIAZDSYlhNv8Y5px0BABRpWXzezXuxPJSjRKmMi/qTku6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Kp1Xwb1S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C4B2606A31C;
	Thu, 19 Nov 2026 03:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Kp1Xwb1S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDDA21F000C5;
	Thu, 19 Nov 2026 03:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057886;
	bh=1jWGACESAuCpQ+LoYUM5hxHRR80QyOGp3w96rqZfhug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kp1Xwb1S0gPH8vJCIEo64H6Ki/A03taLwJXdUVvH/3+bCEQXX8VtDUDEG15/F5ANj
	 enFjDp1KgJP/iyUX1yf5FzAY9RpOqESTJNGfIfa1BrbRTYroAixy3p8fS1SRtNgAaT
	 Y+ZbnA08DFa0YNX46rj8RtU+izasedd7hFC9tOB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 5.10 0289/1848] NFSD: Do not send CB_RECALL_ANY to NFSv4.0 clients
Date: Wed, 18 Nov 2026 15:38:47 +0100
Message-ID: <20261118145924.219193272@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <cel@kernel.org>

commit 95ff0c079b9cab91f2327beb4197a3bc48c71f55 upstream.

deleg_reaper() sends CB_RECALL_ANY to every ACTIVE client holding
delegations, but CB_RECALL_ANY is an NFSv4.1 operation. An NFSv4.0
client's callback service accepts only CB_GETATTR and CB_RECALL, so it
replies OP_ILLEGAL. The decoder maps the unexpected opnum to -EIO, and
nfsd4_cb_done() marks the client's callback channel down.

Nothing brings the channel back. nfsd4_run_cb_work() sets NFSD4_CB_UP
only for a minor version above zero, and the only nfsd4_probe_callback()
call site an NFSv4.0 client reaches is nfsd4_setclientid_confirm(). One
visit from the reaper therefore leaves the channel marked down until the
client re-establishes its clientid. RENEW then returns
NFS4ERR_CB_PATH_DOWN for as long as the client holds delegations.
nfsd4_cb_channel_good() stops returning true, so the client is granted
no further delegations.

Skip clients at minor version zero.

Fixes: 44df6f439a17 ("NFSD: add delegation reaper to react to low memory condition")
Cc: stable@vger.kernel.org
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260817-recall-any-keep-count-v5-1-3b2cffce701e@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -6390,6 +6390,8 @@ deleg_reaper(struct nfsd_net *nn)
 	list_for_each_safe(pos, next, &nn->client_lru) {
 		clp = list_entry(pos, struct nfs4_client, cl_lru);
 
+		if (clp->cl_minorversion == 0)
+			continue;
 		if (clp->cl_state != NFSD4_ACTIVE)
 			continue;
 		if (list_empty(&clp->cl_delegations))


