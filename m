Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057964;
	b=jsWcooRWz0nndwmn5Kd3vQkjSy1T/OaT73YMkoYRcQkpuqk8E/f5nTy5NLyRnG1MyvoT
	 P9Cf9YRggPJSGEmFN+HVpQLUTpZeSTiSxzBNW1yvkUUaW5BcM7tRFPIDOz2lHQT8ixFIj
	 alqZO6PY/ESGm9CEDWuaP84I9Yz+n0hH8abOim9POqoYjXZenA3fBQwhlbDcfFAkzsWS+
	 /QjYybKv2RwaiqU22tskBxjHeCJTb4J6xihh9k+0YaGqB7vZeZCf9bs5IvpKC/q8pn0gA
	 q9pKpTM+2657TvcRduQ5bRmDiaicyKnJRJEwmFH0oapmWWf9vX216NzlI/ecpaGp0lA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057964;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GTH9poCqNzXfSvibJXnlQxLKlOcS6V7VSE7xN22nlwU=;
	b=SCltn98Ucnaeg/mMgOk86i8ZcWrMOw/izSORKnvku6vS0s+ozEsG6QYBrwajtJKKfLn4
	 P7or00B/7b0T3ZYqKGd1w17f7jr5qHtIiqQyVd2Gv+dIHGQiNUQtCVSw/2AA9+w66r4kf
	 53KoGptdr352ws8JqepxWhFUUM27H7Zz2kiz8HDGqvFOA8iQh+IIlfF2U1yTzhdJEa/Xs
	 721VPYiEXaXWh+fdV0Y28gfwpgLyiZxQsS6xIeRlXoRDZFS49l/CbSQDJIDtC6qFPLAml
	 BjZhiA+t3DLbTYHS+inRYMJ47yjh5Ae1TLUjOkhSVmsb/w6tY3mcR1kaK+8pELm8ccg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ExXwzi+8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89442606A31C;
	Thu, 19 Nov 2026 03:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ExXwzi+8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C04B1F000C4;
	Thu, 19 Nov 2026 03:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057964;
	bh=GTH9poCqNzXfSvibJXnlQxLKlOcS6V7VSE7xN22nlwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ExXwzi+8KZbYQ63P8RtupnW/DF/iiT52VmO+cOUL+uh7rRBQ4cp0bcFYJN65nvy9P
	 z2hrHns9zlxDQof/6KEmlXS6ZolT6T4J9Zt3U6M0zAa1gBElax1ydnW04z5KizlOxR
	 lU0Zwms4v/S9Zr7K/1VfVFt2uKae6BJvG9Uhowxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 5.10 0318/1848] HID: roccat: pyra: reject short button reports
Date: Wed, 18 Nov 2026 15:39:16 +0100
Message-ID: <20261118145925.513896223@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

commit 493268f459bb6aeeecbc77f2204c11ad74d05213 upstream.

The raw event callback runs before HID core validates and zero-pads the
report.  It passes the buffer to helpers which inspect data[0] and read a
complete struct pyra_mouse_event_button for button reports.  A truncated
report can therefore cause an out-of-bounds read.

Require enough data for the button report before calling either helper.
Commit 47669bec44fe ("HID: asus: refactor the two workqueues and init
sequence") added the same kind of raw-event length validation to hid-asus.

Fixes: cb7cf3da0daa ("HID: roccat: add driver for Roccat Pyra mouse")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-roccat-pyra.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/hid/hid-roccat-pyra.c
+++ b/drivers/hid/hid-roccat-pyra.c
@@ -554,6 +554,9 @@ static int pyra_raw_event(struct hid_dev
 	if (pyra == NULL)
 		return 0;
 
+	if (size < sizeof(struct pyra_mouse_event_button))
+		return 0;
+
 	pyra_keep_values_up_to_date(pyra, data);
 
 	if (pyra->roccat_claimed)


