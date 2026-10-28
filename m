Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214774;
	b=y2Zh0ptQGE+tLc9gE9aPjZnmDgttvx9kMNz27doi0dy9y+eLyVLYSOvR/Fjwxw4zOfth
	 S4IOQBXpjAnobCQq5fu9EypLl86+wcgMcjTJ3k7UVWFZFeBW2gc/1v3QA0BWnMJklSlhJ
	 3mBTLe56v8WEnn7Z5dnk5Ws7iovW+zLYMSnyCIKoKQft+uSlIgK2ZJcrkE1L1VXiZ0lz/
	 h2Y77mcMOdac0EVeaWsscABvLUC/qATyRcBgdKwG1/9FX0DFYLixVSBJfRIBFdmRuiaIj
	 ScOgipbh2j4D8A9TS4WwHDftD0LFnFSw+cl2kKInHO8do+L1ytcPkqF+WPH28qVOfOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214774;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t+aKZH9g+aJ4jnpfZwM3MGJiJuA8AgUNHR/rSyO9Jx4=;
	b=egIb667wkBbPktDMA14xUmnYdL3cVwuBHgKnKUhQxI+R8SP549j/Lgd+ED56/AjKj6tT
	 9XGhmiRDH27PoWbUhE+lZdC3c7y+xUC/HcxR+L4wGqj1hV1zjjF0G360jVOnibE9bvS3p
	 I6e+GscqF/QhFS9sMEz3UhfPih2bC1NWUNs/uLBFHwklDUQdTOXSakvS8zat2yPfSOPEA
	 20UMoRa01hL1VPCGPKjFy2klwaNKqbQyrBOiQxPSs6jlI+WttClkSqoyCdhsiUpeiRGc5
	 wJsD3xSNn7nrgobUOVQ3TSOAb85mladP9HmpU+9YjM9sAJLfAAuzllQOST0kndHUHXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YyHo2tf9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2739606A323;
	Wed, 28 Oct 2026 19:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YyHo2tf9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FB541F01825;
	Wed, 28 Oct 2026 19:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214773;
	bh=t+aKZH9g+aJ4jnpfZwM3MGJiJuA8AgUNHR/rSyO9Jx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YyHo2tf9yPIJBYCvtjy60QJJtmTD0vZ7DHBhicjsABDjQMOcMAWHQA/YG9OnROz6A
	 XR5jaSXWQyH94QYPWtb3xJHPrcXSbx8vL4Q2hFFKyWDxjTGbyaiERTwKNhIGr3tH7X
	 JQqZ08RK25eWQL9iKRgs+xZyCFINWRv3lTb0bEIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tatsuya S <tatsuya.s2862@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0976/1887] HID: core: Add reserved item tag for main items
Date: Wed, 28 Oct 2026 17:51:12 +0100
Message-ID: <20261028170521.620408842@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Tatsuya S <tatsuya.s2862@gmail.com>

[ Upstream commit c600a55922640b1c4dcfdc5a694cadd2dd9d1599 ]

For main items, separate warning of reserved item tag from
warning of unknown item tag.
This comes from 6.2.2.4 Main Items of Device Class Definition
for HID 1.11 specification.

Signed-off-by: Tatsuya S <tatsuya.s2862@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Stable-dep-of: 0a3fe972a7cb ("HID: core: Mitigate potential OOB by removing bogus memset()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-core.c | 6 +++++-
 include/linux/hid.h    | 2 ++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 3b1952e66ca42..9ad52318a86de 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -640,7 +640,11 @@ static int hid_parser_main(struct hid_parser *parser, struct hid_item *item)
 		ret = hid_add_field(parser, HID_FEATURE_REPORT, data);
 		break;
 	default:
-		hid_warn(parser->device, "unknown main item tag 0x%x\n", item->tag);
+		if (item->tag >= HID_MAIN_ITEM_TAG_RESERVED_MIN &&
+			item->tag <= HID_MAIN_ITEM_TAG_RESERVED_MAX)
+			hid_warn(parser->device, "reserved main item tag 0x%x\n", item->tag);
+		else
+			hid_warn(parser->device, "unknown main item tag 0x%x\n", item->tag);
 		ret = 0;
 	}
 
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 803bbaccec6ab..941a58f4b5bb6 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -80,6 +80,8 @@ struct hid_item {
 #define HID_MAIN_ITEM_TAG_FEATURE		11
 #define HID_MAIN_ITEM_TAG_BEGIN_COLLECTION	10
 #define HID_MAIN_ITEM_TAG_END_COLLECTION	12
+#define HID_MAIN_ITEM_TAG_RESERVED_MIN		13
+#define HID_MAIN_ITEM_TAG_RESERVED_MAX		15
 
 /*
  * HID report descriptor main item contents
-- 
2.53.0



