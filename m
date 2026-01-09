Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E0721A01C6;
	Fri,  9 Jan 2026 12:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961561; cv=none; b=GXgfzck+0+q+Yh4y7zsyG7U3jq9mzOpO2POUS9g8Q48fMQiqZcIkJkSNSL8rUt3RFznNXf0xRdhVdLJ1ynuyb6RLplLWxszeMI2ouSmNxdn2rvvRj1BNaLuf0B30tG6KGHreUuW7h8Q6PXXBXwMLrXYWSNP1lzEwQE0ZF2RPeeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961561; c=relaxed/simple;
	bh=eihSOdOBBxi0rwg8AZ+M1aIXzdmVN/HxGTZjkxbdbUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VOGlsr/q3++wdR0b7Bx4DKLIlGkHqKbCcrk2wu6Fmlv30OaVmF0JPaTseBoUOJhouZjaGNI6fVhyoQbcV+T8GzB+Jj024bzJkbbgGnm9lTMijnR+BndhfillT7UGtlJGmCIrVhjLjzYLRnip5CIIw4dnXqR7B+CfAWysSRbTsTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BSNyF793; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BSNyF793"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C275BC4CEF1;
	Fri,  9 Jan 2026 12:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961561;
	bh=eihSOdOBBxi0rwg8AZ+M1aIXzdmVN/HxGTZjkxbdbUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BSNyF793aAX9J5Hlos7jkKVekvKfr2XijGHcL4aTkJqfvQJbZadNV0NL1M/JVyTLb
	 Nkt1ANNc+K130pxRt5qRnjgCr6oKeI4kCGdR4qpJS21WDb6iJwSPzlRqzHetCIDFJj
	 fSNeRGuTd2vSslKm7S9E+jXbXixx6ZXi9GzptoF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	April Grimoire <april@aprilg.moe>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 030/634] HID: apple: Add SONiX AK870 PRO to non_apple_keyboards quirk list
Date: Fri,  9 Jan 2026 12:35:08 +0100
Message-ID: <20260109112118.581697905@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: April Grimoire <april@aprilg.moe>

[ Upstream commit 743c81cdc98fd4fef62a89eb70efff994112c2d9 ]

SONiX AK870 PRO keyboard pretends to be an apple keyboard by VID:PID,
rendering function keys not treated properly. Despite being a
SONiX USB DEVICE, it uses a different name, so adding it to the list.

Signed-off-by: April Grimoire <april@aprilg.moe>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-apple.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hid/hid-apple.c b/drivers/hid/hid-apple.c
index 76b76b67fa860..2de1a97eafc14 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -320,6 +320,7 @@ static const struct apple_key_translation swapped_fn_leftctrl_keys[] = {
 
 static const struct apple_non_apple_keyboard non_apple_keyboards[] = {
 	{ "SONiX USB DEVICE" },
+	{ "SONiX AK870 PRO" },
 	{ "Keychron" },
 	{ "AONE" },
 	{ "GANSS" }
-- 
2.51.0



