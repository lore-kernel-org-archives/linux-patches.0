Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029481;
	b=gZpCxcCqRy8iMs3Nd3qvETd8BM+I0HZt0SmqSIsRCo724xf6HqFVWhbebBNh199As5cg
	 PhCg6Y95zFTMufsTGQDbBEZuAPzXGunmz4yCnartzPwKWYqEAcxXT1CwWUgxKO9eebdy+
	 JZx1yRs2YfvADg4HA7MuvTOOy1DJmko6+5TaomuJ9cw4ET2KfGTDyZmB8fuW3kv9UOYag
	 K3mQDAid5hUgrRNCdZdQtn5VxeYnlVzD8l0dqaglwymNdy99lz7qIpxg22rGkbsf+lwrb
	 LoSLeb8oCthYoHvflmN6mBHDvU2lnzP2QaCPWw/+uriI8ZRPDHjF2s7ARvxEFazChtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029481;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=29Kj/eSaKkr6pfh5MbVs0lBtGdU1EJz5T+YB8Ye3/Mw=;
	b=2bOTvMlaS9fLyadTWRj3WABFURqYo3WTRqVUlcdHLUSL8IOyZNdbxvYD3/qYRSqsz9P4
	 kokrKKEbF1vbEqhNGDzsslEW3CxsR4q4D009VlPtHGammRc+/3eLNdyMfw8eHA7sZUs3E
	 V9wtZAm39AkrdqPvJzXkcJ5/K/Wpb6m+TBbwB+2hUzxK4ZdsvE6tL39imlPGSzZ1Sqh/M
	 AwHhUx9MLDdT7m9lHpvyIHkBraHvWBkcgGmBm8S2nBgYhP8icFW50B7xTncb3XDqtKimb
	 bNz+4YCo4OeDNnvKMeewDfiO4o0hb9jIQQcUhUyK61zUEztmYjQF7KjoZMW8LBH8ZGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="OSwMa/jZ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12D9B606A31C;
	Wed, 18 Nov 2026 19:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OSwMa/jZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 248E81F000C4;
	Wed, 18 Nov 2026 19:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029480;
	bh=29Kj/eSaKkr6pfh5MbVs0lBtGdU1EJz5T+YB8Ye3/Mw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OSwMa/jZ49pAEpFQRStWM/T6Ic6Uydw7oCoUYMb8tLwHLe7WZQ/c9hVshg7R0+eAo
	 j7ubRzcugM562n69DBFENxS5xc+qqB0DsEvCyKZg3BlZeDb+z2KmMIsKUOETlTEmQ+
	 gxQbjid6uWlVkT/jJrAoo0kcRXaJ3u3d6yWNHB/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0363/1756] firewire: core: remove unused link field in fw_packet structure
Date: Wed, 18 Nov 2026 15:41:30 +0100
Message-ID: <20261118150022.767332758@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b632eec3ab526..9e7ff7c3b7398 100644
--- a/include/linux/firewire.h
+++ b/include/linux/firewire.h
@@ -312,7 +312,6 @@ struct fw_packet {
 	 */
 	fw_packet_callback_t callback;
 	int ack;
-	struct list_head link;
 	void *driver_data;
 };
 
-- 
2.53.0



