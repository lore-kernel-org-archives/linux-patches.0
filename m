Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B6A2572
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:48:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0F21C4339B;
	Tue, 18 Apr 2023 12:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681822080;
	bh=aXSOuYvmTIaGUJwOusY2pcfU4RwwyLNCWcxY7NsZPKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ofc9t9SCq4ytg3w1P17YVULEbv9gVDHjW6LD0Du/y0aP93nrYisQiofYh9fXS8YbL
	 2YoCIVHx1A20HQ3/OVJWpZK3CcRIkd+O6D0+nUDLpSxmdKVhq9/70Ur5UbPLCufLeL
	 HF8ZJ1pMf87xUFNMF2G8FPeeu2Gs+ZJn95vlKiYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Finkelstein <fnkl.kernel@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.2 015/139] bluetooth: btbcm: Fix logic error in forming the board name.
Date: Tue, 18 Apr 2023 14:21:20 +0200
Message-Id: <20230418120314.253949729@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sasha Finkelstein <fnkl.kernel@gmail.com>

commit b76abe4648c1acc791a207e7c08d1719eb9f4ea8 upstream.

This patch fixes an incorrect loop exit condition in code that replaces
'/' symbols in the board name. There might also be a memory corruption
issue here, but it is unlikely to be a real problem.

Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Finkelstein <fnkl.kernel@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btbcm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/bluetooth/btbcm.c
+++ b/drivers/bluetooth/btbcm.c
@@ -511,7 +511,7 @@ static const char *btbcm_get_board_name(
 	len = strlen(tmp) + 1;
 	board_type = devm_kzalloc(dev, len, GFP_KERNEL);
 	strscpy(board_type, tmp, len);
-	for (i = 0; i < board_type[i]; i++) {
+	for (i = 0; i < len; i++) {
 		if (board_type[i] == '/')
 			board_type[i] = '-';
 	}


