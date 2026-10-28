Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213292;
	b=wdjgF5kENkaWG+nelmMjYqAuwHATkIvYwS0SAOiX/QuwZgMYWLxK6Qu0k6OuX5ZStnit
	 HPdCyhPed+j+23Izqa25JZ0GZoLsRap5X7oagOV48oLsrp5Gyjy9J0/Sz5P7ziCt1RKIa
	 KxPTCrRCRyz4q7U+pn5wtrgKRYiTc8Xia0TAxjJnizH3e5NMeurOvuQG7CWShsqzItaA5
	 J50Kc6CDmUIqAkigUaYwTh+Ok11rdkmKBRgFZfc0Hr7IRg+6SF0Ty1WKzov0Jb08F1qrL
	 XosKQdVIHis6zo3iLLsoRDpYrcmDyzW0rKJ++pQkz+N0Nu02KkwsZUGMk14ieGRc8xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213292;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Dn25BEj0ZQv4prVrYH/H//MoTM5heBO0KjA6s3fnae8=;
	b=ui0m8Gv4Ncy5OxJfYFyEz3RPN0cbK6TyGUJn3++Z5sFfUu71YCVlmdts8vm0y1pzk/Tc
	 Dm0B1GSqPp9+XlBqjMnLqusDr0FjiGbSDqtm+Js/iPpC0JGyNfNma8XXirBXoaXWFS7A6
	 UzKPhAcocZHSHmzE9hzvtXRR5RC/dEHV+OfiGzkMNv1O7puNAOUszFtxlJJURPTdxFxwb
	 QqyZWEHdWpSRN+7SJ4u347QJmNkiGmUteWFLHmihhx0op90D5IhOuxvRhcWN3f9Zbhl5D
	 68gF3CXpXyh+39xC8GS4rJgurprn3df/ICf348wi73qIsL408tGxGBNlXXVEw7602iA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=arKNTITe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8277606A31A;
	Wed, 28 Oct 2026 18:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=arKNTITe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECAAE1F01825;
	Wed, 28 Oct 2026 18:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213291;
	bh=Dn25BEj0ZQv4prVrYH/H//MoTM5heBO0KjA6s3fnae8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=arKNTITem3m3Xx3rDybDH+syN85oM2RykoYHrjIg5QHolK7cOO593tmuI5hMT5anJ
	 RqEe1l09xF0bklVoPplQowCiPyOCHieVtYjwnb9MLsn81E+7Lv2eqEMuuLsiHtSV1u
	 7/aERc3Poy1x9TPrgvs3FkQU2qo6WdarTlJI0bvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+48d935cf48a4a76be346@syzkaller.appspotmail.com,
	Palla Raghunath <raghunathpalla.0209@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.1 0437/1887] dm ioctl: dont let data_start run past the buffer
Date: Wed, 28 Oct 2026 17:42:13 +0100
Message-ID: <20261028170509.176271917@linuxfoundation.org>
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

From: Palla Raghunath <raghunathpalla.0209@gmail.com>

commit 9b3fcf519d370df94a56f3b272d9eddffffa5be8 upstream.

struct dm_ioctl has seven bytes of trailing padding, so the smallest
buffer userspace is allowed to ask for, offsetof(struct dm_ioctl, data),
is seven bytes shorter than sizeof(struct dm_ioctl).

get_result_buffer() sets data_start to sizeof(struct dm_ioctl) without
looking at how big the buffer actually is. Ask for the minimum and
data_start ends up seven bytes past the end. Callers add it to
data_size, and ctl_ioctl() copies that much back to userspace:

  BUG: KASAN: slab-out-of-bounds in _copy_to_user+0xad/0xd0
  Read of size 312 at addr ffff8880169e4c00 by task repro-dm/140
   ctl_ioctl+0x5e3/0xcb0
   dm_ctl_ioctl+0x25/0x40
  allocated 305-byte region [ffff8880169e4c00, ffff8880169e4d31)

A DM_LIST_DEVICES with data_size set to 305 is enough to hit it, and the
seven bytes that leak are whatever sat next to the allocation.

Clamp data_start to the buffer size.

Note that this is not a security bug because the out-of-bounds read can
only be triggered by root.

Reported-by: syzbot+48d935cf48a4a76be346@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=48d935cf48a4a76be346
Fixes: 76c072b48e39 ("dm ioctl: move compat code")
Cc: stable@vger.kernel.org
Signed-off-by: Palla Raghunath <raghunathpalla.0209@gmail.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-ioctl.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -545,10 +545,16 @@ static void *get_result_buffer(struct dm
 {
 	param->data_start = align_ptr(param + 1) - (void *) param;
 
-	if (param->data_start < param_size)
+	if (param->data_start < param_size) {
 		*len = param_size - param->data_start;
-	else
+	} else {
+		/*
+		 * The buffer can be as small as offsetof(*param, data), which
+		 * is less than sizeof(*param), so don't run off the end of it.
+		 */
 		*len = 0;
+		param->data_start = param_size;
+	}
 
 	return ((void *) param) + param->data_start;
 }


