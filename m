Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76B1C1B4231;
	Tue, 15 Jul 2025 13:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586650; cv=none; b=ij6IT2K1l36jGL6l2vOV/isFSuYl3qD0D0DHJvtZjmLiRy6lvUeJVHfs7Cymco1pXZGgjKmwt75cHWj8UWQ5xi33gxz9qnGCCcVB2hNPCFuO5eEkkSOi5DUcDI6lFLRX+mI6U/HUJjDA8tdZZ7QfvHh46eziERY/r1bTGOpQdug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586650; c=relaxed/simple;
	bh=fZevT78siy67cITHvoPyg6ISzq4OqASjGbYxETc9GUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ct4a7Nowlg7qkY96BTR46Xq2srzNU81LLBh+Ksm8H+K9vaqQBsuHNidGaoXu1q0n4QZmohYKwaYmea8LFjdvg0kg3gIU5WHSY4+da5eLNcMt+QHWflt8S5q2GkJ0djrmiOTCJBZ0bOZ1HjH7neW0iNjXQtfU9JP9rASk2ES1MhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jKS9O0T6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jKS9O0T6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08ADAC4CEE3;
	Tue, 15 Jul 2025 13:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586650;
	bh=fZevT78siy67cITHvoPyg6ISzq4OqASjGbYxETc9GUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jKS9O0T6ogknnFu4in7rB2DDn+HT3eDo79a8AwfZ6cT01sPkkDgU6XVupYy76C3ml
	 9BOLOPtHQq+mXdMnaWlMWdsbywJz+ZvOCcFyZUna9F5H2Csp8lyUvK+aIq1VdmYn4K
	 1RTQ2pHUu6ykEPRQrOUskHCZoGo4fsslWQWjFu3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Hans de Goede <hdegoede@redhat.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Wang Hai <wanghai38@huawei.com>
Subject: [PATCH 5.4 146/148] Input: atkbd - do not skip atkbd_deactivate() when skipping ATKBD_CMD_GETID
Date: Tue, 15 Jul 2025 15:14:28 +0200
Message-ID: <20250715130806.120720190@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 9cf6e24c9fbf17e52de9fff07f12be7565ea6d61 upstream.

After commit 936e4d49ecbc ("Input: atkbd - skip ATKBD_CMD_GETID in
translated mode") not only the getid command is skipped, but also
the de-activating of the keyboard at the end of atkbd_probe(), potentially
re-introducing the problem fixed by commit be2d7e4233a4 ("Input: atkbd -
fix multi-byte scancode handling on reconnect").

Make sure multi-byte scancode handling on reconnect is still handled
correctly by not skipping the atkbd_deactivate() call.

Fixes: 936e4d49ecbc ("Input: atkbd - skip ATKBD_CMD_GETID in translated mode")
Tested-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20240126160724.13278-3-hdegoede@redhat.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/keyboard/atkbd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/input/keyboard/atkbd.c
+++ b/drivers/input/keyboard/atkbd.c
@@ -776,7 +776,7 @@ static int atkbd_probe(struct atkbd *atk
 
 	if (atkbd_skip_getid(atkbd)) {
 		atkbd->id = 0xab83;
-		return 0;
+		goto deactivate_kbd;
 	}
 
 /*
@@ -813,6 +813,7 @@ static int atkbd_probe(struct atkbd *atk
 		return -1;
 	}
 
+deactivate_kbd:
 /*
  * Make sure nothing is coming from the keyboard and disturbs our
  * internal state.


