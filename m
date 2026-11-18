Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055012;
	b=Vy9D8Qn+/ifwtU6kTqbOXsNc6K8+mvFSprHpM67H9fWVgzyNw9/rUciLaTwcOmeFcyCB
	 iuK/Vup98qAzdFR0PcSMSHuJegDUi9tDVt83VoLljtra5QsKcDYFD+/2Xwe8hABF4bFJn
	 jflrVtUOCGY19yOW6SJP2RFw9ikH9u9fMoTHB4PB9VxCMxCOI6VlQXhAlSdA1VD+C4eAz
	 9cdnUBEzlp8giq5GZ+SKPFjmglvYiJjcO01rCsOb/Y2LWIs33FBtor8K+gFgo3cW7l4Xa
	 ZBgd/bFUXdnyUgKZbyxbApMS7mr4TmPwTdhvnaiWxD7kC8sNQto2YuNNMfz0Q9FfTPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055012;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QzTjRD7mAdIOdo54Vyac7ISxWJT1EHpld5n69GODjuQ=;
	b=I0cRPao+QOqmlDU0mAmCyjlFgK7eGHYo+pt+TPL5ce+1joyo+q5wSx0yODNQgyVRqgaY
	 +TyxW2UsU+SwAZXw2Kh7zfiUWcOEhJYIgBfCRx7xEaHxcXCcHoa0cIlbmUwJjMh95UcIj
	 KJ5BGp1Csh/wQuKktWQ11J2fLxI8wchb7Nxrz6C8YnfLsv6OaySLv1nm0bQXK7uyQVs6o
	 YiY691lJBeH1eqo6kAz5FrSI+y29F6SKbOZVXNnecLya1/xrkv3S6p4CQeYY3LCYWRfxB
	 5Qhx9oXG+JnOO7q4/Zcpk2arV8yh1O9J3+W44MCBtGV2BKeeODBSdAvWtet39LXEUJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oYh7a+0Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D993606A31C;
	Thu, 19 Nov 2026 02:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oYh7a+0Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABDC71F000C4;
	Thu, 19 Nov 2026 02:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055012;
	bh=QzTjRD7mAdIOdo54Vyac7ISxWJT1EHpld5n69GODjuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oYh7a+0QBo3lCfl2fVSQLQxNLe2xNqhUYYLlGCzeql1HQyknX4VhrwbAjbBbUWIB6
	 iCsF+nz6ViaRPG1QgXM08qVTlbtEeqIA0+ierVIAOnymfBGGBFRWMBmjYQW7uPQhKc
	 Qep3MlK69ZKy0J+kxQHgzrlu4VXhy4YakHsM56O4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1480/2214] firewire: core: remove unused link field in fw_packet structure
Date: Wed, 18 Nov 2026 15:52:36 +0100
Message-ID: <20261118150110.360526166@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index aec8f30ab200d..6395605e91fd0 100644
--- a/include/linux/firewire.h
+++ b/include/linux/firewire.h
@@ -309,7 +309,6 @@ struct fw_packet {
 	 */
 	fw_packet_callback_t callback;
 	int ack;
-	struct list_head link;
 	void *driver_data;
 };
 
-- 
2.53.0



