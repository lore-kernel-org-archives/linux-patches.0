Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB7A1DD0EF;
	Wed, 10 Dec 2025 07:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765351925; cv=none; b=OR7K4Mr5/KRv3PtmPcrxBDUnLkbeVfS0cBkBMus/9jD6niR8iXGnXrS8m2EHbrtyiBp4gtyourmCBdfm7jfYXKQREcuDqPaN0BiZMjQ7qv/zW2Ny5Ty0WYN7rUSSc975VtJZFxZ9zCxPfyttyx3u3HJ9Iku28vE+3L1PqC9c1wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765351925; c=relaxed/simple;
	bh=9Y8p5OBY5/7YfQVPVux2O/YMMZR5Q/C5Z5blJZsbj/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SKOGzrz3xAb2YiAlnKCwBL/mdwmxPK+t8Q0h5PGfZjJPp0XDXPYssj+SgmciQqfuSCX77+hw6eoqg30QN+ihR7ndBSzN8Q6IX7T9P76P5c3sHRQO4ZEMMAcmDS7oCiW3g5cClVPSSQwCchCn99i1gnOx+nyD+isslupwKYAAo80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=flccbAEw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="flccbAEw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A22CBC4CEF1;
	Wed, 10 Dec 2025 07:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765351925;
	bh=9Y8p5OBY5/7YfQVPVux2O/YMMZR5Q/C5Z5blJZsbj/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=flccbAEwXtNpjzSDl1LIAj3+5xnYsulVFTKzhyzFRQ1gmtEYhVYeu09m1jzVocRh4
	 jrOyQUGun6hIXtxG9YfeNERY9+AnxyCCftt7b2Pq1sj7ST215LDYbi4gmvCdlld0ny
	 1E1gSNTee0XjG5vG7WDHVqXgmRaoqdt6iRBdU/ZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	April Grimoire <april@aprilg.moe>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 33/49] HID: apple: Add SONiX AK870 PRO to non_apple_keyboards quirk list
Date: Wed, 10 Dec 2025 16:30:03 +0900
Message-ID: <20251210072948.988605734@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210072948.125620687@linuxfoundation.org>
References: <20251210072948.125620687@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 25d1edb6a2107..a0f79803df3bd 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -354,6 +354,7 @@ static const struct apple_key_translation swapped_fn_leftctrl_keys[] = {
 
 static const struct apple_non_apple_keyboard non_apple_keyboards[] = {
 	{ "SONiX USB DEVICE" },
+	{ "SONiX AK870 PRO" },
 	{ "Keychron" },
 	{ "AONE" },
 	{ "GANSS" },
-- 
2.51.0



