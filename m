Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19D5612C48A;
	Tue, 30 Apr 2024 10:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474669; cv=none; b=fYAB+5KqZpQJ0QN9+2Vi0LubstYTW4GKjUAbzhLCk7MXXmjW9m21CwIT0OE7K9PIph5BYORnmuo60v2N+FuSdTjmRICgThw5B4rMYqbo13JWXT+ZdR35qk/1KkD7gWQYYjcMyuPxct9AdenZFPM6BOx2JM+QPxmImqQA/KZABr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474669; c=relaxed/simple;
	bh=4vCvhb0i88ZZpiVWuIzNTQehxlW+LSB0ZGdK/mSKmAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iG0xpuFeR1miSpX9UOZkymcl8bf5LZLvy1Qa6WKLBbXT9fMUod5+7Enyynh9p2LHGTxJr7gd7rqMEFbT/+MCZ2M4qazxwiiphdo86eJ2frDYXMRMMFGzmcdF3qSq6XrMXUpaMHIfvC0pQjzGSX5Wg4S4oAMnM9tI7tvSwK5ZS6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DP4RZ1yy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DP4RZ1yy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79D3DC4AF18;
	Tue, 30 Apr 2024 10:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474668;
	bh=4vCvhb0i88ZZpiVWuIzNTQehxlW+LSB0ZGdK/mSKmAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DP4RZ1yycCygVP/CyhDVNyKUM0SX5/U7ig9GehwTdy9bTP6BlwSujbL8TakgGb2xb
	 SFebSzhktvaRwjn6Q2oDD3Q7PKniK3nnH583hP0hiVcc/VPIJmmWTSjFC3J2t0uqxr
	 7jpLyNVikZrUne2HSXgqBgI6QrnOD/BjSOx60pmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	Benjamin Poirier <bpoirier@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.8 188/228] macsec: Enable devices to advertise whether they update sk_buff md_dst during offloads
Date: Tue, 30 Apr 2024 12:39:26 +0200
Message-ID: <20240430103109.226320154@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

From: Rahul Rameshbabu <rrameshbabu@nvidia.com>

commit 475747a19316b08e856c666a20503e73d7ed67ed upstream.

Cannot know whether a Rx skb missing md_dst is intended for MACsec or not
without knowing whether the device is able to update this field during an
offload. Assume that an offload to a MACsec device cannot support updating
md_dst by default. Capable devices can advertise that they do indicate that
an skb is related to a MACsec offloaded packet using the md_dst.

Cc: Sabrina Dubroca <sd@queasysnail.net>
Cc: stable@vger.kernel.org
Fixes: 860ead89b851 ("net/macsec: Add MACsec skb_metadata_dst Rx Data path support")
Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Reviewed-by: Benjamin Poirier <bpoirier@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://lore.kernel.org/r/20240423181319.115860-2-rrameshbabu@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/macsec.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/net/macsec.h
+++ b/include/net/macsec.h
@@ -321,6 +321,7 @@ struct macsec_context {
  *	for the TX tag
  * @needed_tailroom: number of bytes reserved at the end of the sk_buff for the
  *	TX tag
+ * @rx_uses_md_dst: whether MACsec device offload supports sk_buff md_dst
  */
 struct macsec_ops {
 	/* Device wide */
@@ -352,6 +353,7 @@ struct macsec_ops {
 				 struct sk_buff *skb);
 	unsigned int needed_headroom;
 	unsigned int needed_tailroom;
+	bool rx_uses_md_dst;
 };
 
 void macsec_pn_wrapped(struct macsec_secy *secy, struct macsec_tx_sa *tx_sa);


