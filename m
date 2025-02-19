Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74FCD1C5D56;
	Wed, 19 Feb 2025 08:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739953862; cv=none; b=cWC7hv21wk62PxprRBeRWfRkrTjkORJnmB8LqKLJ2Qh4y7duWmm4fktisDQkJMIkvA97Nsrlk/pkYn5fBWGb30LcijGezQup9DBzYK9VQgBsS83jJQXR6VbLb2lGAl5mgxlGJPo3vIaKBTpYuhtl1ZuaoPxMWLDdWypTQOKEFB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739953862; c=relaxed/simple;
	bh=v0sDaFTaE8wWkPHqsJWIggJhyCNZ2gkZGy0XqHhShz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HLSIckLMToGeeLYVr7KdUXo3QPbAV0ex/YjhJhS+zsB4ZKEC0sTlrDpWuXwE/6crb5Aipyhp9Vc6BZcHicYpu4mmiS8NQxvCFvc1Se4F7bYBlEmlRUUuQ/bbuUDZQ/AJNiCkJJ5aTDKaqbPL6aUz2dZMbfC6sqUvrZu9TZrPJc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c9hJ53bA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c9hJ53bA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE398C4CED1;
	Wed, 19 Feb 2025 08:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739953862;
	bh=v0sDaFTaE8wWkPHqsJWIggJhyCNZ2gkZGy0XqHhShz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c9hJ53bAZUXXekN2c+B6Zqtr+JSBCi6N4hPLQxHgW4JYrd8s5FoBv5LMSXX/QYbG3
	 E7+P+tsNYD0PwJpjvXnHYPrVB+8tvvWmpczGkLgVdtQIU9YHCmA7tvLJuJRVwj/e//
	 UJ3kpwSMhidL+ZgSFotc3ocOTuwgcvZk38Tbodi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Reyders Morales <reyders1@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 021/274] Documentation/networking: fix basic node example document ISO 15765-2
Date: Wed, 19 Feb 2025 09:24:35 +0100
Message-ID: <20250219082610.368749329@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Reyders Morales <reyders1@gmail.com>

[ Upstream commit d0b197b6505fe3788860fc2a81b3ce53cbecc69c ]

In the current struct sockaddr_can tp is member of can_addr. tp is not
member of struct sockaddr_can.

Signed-off-by: Reyders Morales <reyders1@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://patch.msgid.link/20250203224720.42530-1-reyders1@gmail.com
Fixes: 67711e04254c ("Documentation: networking: document ISO 15765-2")
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/networking/iso15765-2.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/iso15765-2.rst b/Documentation/networking/iso15765-2.rst
index 0e9d960741783..37ebb2c417cb4 100644
--- a/Documentation/networking/iso15765-2.rst
+++ b/Documentation/networking/iso15765-2.rst
@@ -369,8 +369,8 @@ to their default.
 
   addr.can_family = AF_CAN;
   addr.can_ifindex = if_nametoindex("can0");
-  addr.tp.tx_id = 0x18DA42F1 | CAN_EFF_FLAG;
-  addr.tp.rx_id = 0x18DAF142 | CAN_EFF_FLAG;
+  addr.can_addr.tp.tx_id = 0x18DA42F1 | CAN_EFF_FLAG;
+  addr.can_addr.tp.rx_id = 0x18DAF142 | CAN_EFF_FLAG;
 
   ret = bind(s, (struct sockaddr *)&addr, sizeof(addr));
   if (ret < 0)
-- 
2.39.5



