Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 852FD223710;
	Thu, 17 Apr 2025 18:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913252; cv=none; b=uVnFLJ3HmreruPzW7JGUCpOWjJ1tP85iK2TbYcAQbNxE60jxpUqALu8f2ivikhO+Pb5ivwEirDLrvvoPC7ZY5wAK83m0JWJ6YNO1biyg02chzPoUOlmF9ugOYVAxp4dHP9ZguiPTk2L4zDnkBF4mLHyK2aRHEDVbcTwiTvIUrCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913252; c=relaxed/simple;
	bh=YBfHONti5YJblOwD8/7wiDFzhr6NNu3pEnXKME9IHjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VnmQpW4Z/aJ+Mzj32cUDIamTPICdBiy7Dfur+gSLaDMwbdo6JZeqaI2wbu2XARaVSbUv3QsDP4rnJ5IdsxnDm/U5SeGfeeXHNJeuJIf6aXGVjZPHEv3HAQQOs1Wdrrkqo+YxSXceDPkRLt9tK5sl81/VZwQDm/SV8S5QBobqy94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n+km1Lxj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n+km1Lxj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1677FC4CEE7;
	Thu, 17 Apr 2025 18:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913252;
	bh=YBfHONti5YJblOwD8/7wiDFzhr6NNu3pEnXKME9IHjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n+km1LxjsYd6vSpgLa7IL5z59v03z+pSMf6VdPQ5Nu9MOkfbcewywT3lf3osbUT1D
	 BlJHO4tzn7yLEAuPXGiRydUL1JVt8795tzyp3jDBU4ClE9Jj9uT/HSv3MaWbqjJv7k
	 yfiuDezBAuQau6uKDR7vYuQsR+Ob89FvWYFLNdc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.14 278/449] wifi: mt76: Add check for devm_kstrdup()
Date: Thu, 17 Apr 2025 19:49:26 +0200
Message-ID: <20250417175129.250311268@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

commit 4bc1da524b502999da28d287de4286c986a1af57 upstream.

Add check for the return value of devm_kstrdup() in
mt76_get_of_data_from_mtd() to catch potential exception.

Fixes: e7a6a044f9b9 ("mt76: testmode: move mtd part to mt76_dev")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Link: https://patch.msgid.link/20250219033645.2594753-1-haoxiang_li2024@163.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/eeprom.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/wireless/mediatek/mt76/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/eeprom.c
@@ -95,6 +95,10 @@ int mt76_get_of_data_from_mtd(struct mt7
 
 #ifdef CONFIG_NL80211_TESTMODE
 	dev->test_mtd.name = devm_kstrdup(dev->dev, part, GFP_KERNEL);
+	if (!dev->test_mtd.name) {
+		ret = -ENOMEM;
+		goto out_put_node;
+	}
 	dev->test_mtd.offset = offset;
 #endif
 


