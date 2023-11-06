Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893E420B00
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zlh3BQOa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 058B1C433C7;
	Mon,  6 Nov 2023 13:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699276842;
	bh=s9WoAAkXv8yr7MkklaFMaRKIIZh4RepWB+IFWaYgjHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zlh3BQOa+6FBzY4W14rTu31sw66ji3NFb5Pztc0hO/+Qsj8VYN+a2Fa02wIbFEkzu
	 hpXAdbLS2wMMWPMu1YPXfu1cyjDlenD+v1qFu42Fg6sxGKwT0nt5MNr0G88cgyI0gg
	 JD7/GjPIM4T8xrdKgAespoqhkNeRnP3mGYe3yFQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 18/74] gtp: uapi: fix GTPA_MAX
Date: Mon,  6 Nov 2023 14:03:38 +0100
Message-ID: <20231106130302.332502136@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130301.687882731@linuxfoundation.org>
References: <20231106130301.687882731@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index c7d66755d212b..78bd62014efd3 100644
--- a/include/uapi/linux/gtp.h
+++ b/include/uapi/linux/gtp.h
@@ -30,6 +30,6 @@ enum gtp_attrs {
 	GTPA_PAD,
 	__GTPA_MAX,
 };
-#define GTPA_MAX (__GTPA_MAX + 1)
+#define GTPA_MAX (__GTPA_MAX - 1)
 
 #endif /* _UAPI_LINUX_GTP_H_ */
-- 
2.42.0



