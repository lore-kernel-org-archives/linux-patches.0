Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048191;
	b=f7MNGPjCczOG8JwGdqWjcXf09NjCygSNCrahK+I9imsZ7Z/ulgMWFqnqd8209BHW/Fza
	 pxZ+Zx2QfC0g1fCW6/AIeHEvpdSL55SPTQoDbslBve5TsOQKK5lbIxvcLP20Xs8lODQss
	 24kgD/kzlYXaNFEJcjizfgDqsuaKCslVuNIGyiV4kCg3huz4wEWD1VZBjRl2fh19sRtDj
	 QuyRpwy7TkJPwRUK7miGqdWHcAJPxFoYVhTBrFSgPYfTknNfDDQnNGvALBGKsRPmvobst
	 AWzNLhq7ID/sLvni8jQPfByRfVzr6nwr9OhIltkIfqdViyI2R3bKb3zilI+Neuah5Jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048191;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9hC0h3DlOMNTxKrtEi5KLRxrC6Fi4uoLpwZaSg3mEXo=;
	b=V4CXzbRIKQaSLGAil2rmbQBHN65Tt+PATxF6VCr4sf+LoUibJGNvduFbbddzMlKVb+Zt
	 Jbi3/4sCpBQ74/h7e71qVZgOtUK7tpjkXuxdSKfp48R3AIkCIzcpPT+7YbQKhPFwa82gz
	 HIhcAxCT997FgRVXZX803a0iO03aucYGrjiUrwxTr6CWWquMVSmyYwL5ddQUI7y0hTRVA
	 EWaRKIFULl70lMlUtM804t8TAXewVuSSHXDC5gNXM5PmQTvqcud4ZQtAcBulu/IzxtvyU
	 B9JdRMN3a2Bd1FWVeA2o7l91MFugeD9s+hdPTaSah0dN5K1nRGpI39lGgdk+EJFZvdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t3nYLTqO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BEA7606A31C;
	Thu, 19 Nov 2026 00:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t3nYLTqO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A5E41F000C4;
	Thu, 19 Nov 2026 00:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048190;
	bh=9hC0h3DlOMNTxKrtEi5KLRxrC6Fi4uoLpwZaSg3mEXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t3nYLTqOIOrJgHGyuxur5C8BfIA4FhlIZK7guPKIH3bSHmtYk3vPhY7/I3+c2QuAD
	 jbhkWTQ2IvnPebeIfhaQi3vqtKaRZ0ish8Z+bKySYr3nWWS7mfxPm5IObz9OVWBQm7
	 1kW8xRWkZU7QSAlHlOyIWTck2GN6t/mVAkcZzXZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1900/2857] firewire: core: remove unused link field in fw_packet structure
Date: Wed, 18 Nov 2026 15:48:54 +0100
Message-ID: <20261118150309.645514384@linuxfoundation.org>
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

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

[ Upstream commit 00d4d31e4fdfe51312f0184f8d162b8d4de172dc ]

The link field in fw_packet structure has never been used since it was
added.

Fixes: 3038e353cfaf ("firewire: Add core firewire stack.")
Link: https://lore.kernel.org/r/20260911141602.3288806-1-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/firewire.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/firewire.h b/include/linux/firewire.h
index 980019053e541..b7cbdef08b9bc 100644
--- a/include/linux/firewire.h
+++ b/include/linux/firewire.h
@@ -311,7 +311,6 @@ struct fw_packet {
 	 */
 	fw_packet_callback_t callback;
 	int ack;
-	struct list_head link;
 	void *driver_data;
 };
 
-- 
2.53.0



