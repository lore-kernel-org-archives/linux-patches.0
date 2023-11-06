Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F6E722EED
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gMvWt3gb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E06D9C433C7;
	Mon,  6 Nov 2023 13:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699277439;
	bh=AwaC2RJ62V+u7I4wYhum2fCq/p4vYBsC0JZ3cRp6xLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gMvWt3gbq8zQxCgkX5RhTifOWOH46eBK+PfWPG0rAX/lD3so92+sDIQ4wXgC3Z3Ob
	 HsF07Kgl7aD0yTftlYV0xKA/eeyL+XP8SAjul6CLazy5Pe1mmnU7AUfJhYa4YTxzal
	 ruG68fzCfjgBtkU/lJaBl59JYyK/9i/HE+zfLF+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 22/95] gtp: uapi: fix GTPA_MAX
Date: Mon,  6 Nov 2023 14:03:50 +0100
Message-ID: <20231106130305.531392891@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130304.678610325@linuxfoundation.org>
References: <20231106130304.678610325@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit adc8df12d91a2b8350b0cd4c7fec3e8546c9d1f8 ]

Subtract one to __GTPA_MAX, otherwise GTPA_MAX is off by 2.

Fixes: 459aa660eb1d ("gtp: add initial driver for datapath of GPRS Tunneling Protocol (GTP-U)")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/gtp.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/gtp.h b/include/uapi/linux/gtp.h
index 79f9191bbb24c..82d0e58ec3ce2 100644
--- a/include/uapi/linux/gtp.h
+++ b/include/uapi/linux/gtp.h
@@ -32,6 +32,6 @@ enum gtp_attrs {
 	GTPA_PAD,
 	__GTPA_MAX,
 };
-#define GTPA_MAX (__GTPA_MAX + 1)
+#define GTPA_MAX (__GTPA_MAX - 1)
 
 #endif /* _UAPI_LINUX_GTP_H_ */
-- 
2.42.0



