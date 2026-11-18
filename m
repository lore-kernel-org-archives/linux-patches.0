Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044622;
	b=YuwAfaxkFVroeWvjSXkZpWb4OT9Y7txva3/217NjKD/dsfob75a8IcMUmYa/M49fnpav
	 tudP5H8k09OzrrwoSiAJJh3Z5N5u8s0pAhzn1ojY0SobFyz1NasiWvQzzYykiRm7mzAtB
	 c8OcJFM5wn/lFIWiJrODquezrQFekK15ACizresdA3eDpZjEw03KCdeI4ZmX8vr76ub8F
	 hxfItiEu0zSGiCKAYf7SPDSLJIc85Js9N2S73Ku/3rhsobOGKg8zSaSp350bvCgWOFUSh
	 WrRAkZBEjDOA/0Fvxt/qHocqPwaPjKVkbzQ5pVvNZ8fU5BeFJY8mR5FZWisL7a67oSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044622;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=APziOsEBxMfPsWqbMzKyOiX8laPNnr2Zqvm8xgpmgTQ=;
	b=0+gChUlaLbMmpBS8jqdFnnIDO62mtVZ8d+E6MjsfMqKn2pNmoIpXamAKFKhF+irhL8Jv
	 fOqVtXreIcKPWYoSZAej7FVZaQx8bHO9l62p00ta7imthO6qdxab94wYykr6kpqISeewE
	 +mw7o6BQqWGY2xWgLoWMT4bS0QNB8Bjs9w2Gvg01Mv9lSwuBT05tFObvQ7kdW495VAr1l
	 /SHDnXwPx/mrCK1JQ/Lr1AP9v+qgQ+qVCz0+6IM/+8Gxxp8DRhMfiwVuBpKwsRqamvuzp
	 DLWCgIfHcFgYY60qbcKrdISVne5Fgh9h5KTsVugf/IUVP90oU3Hrfxm5WDPE+IM9uUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="FD7HjD/l";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1918606A336;
	Wed, 18 Nov 2026 23:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FD7HjD/l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2759C1F000D1;
	Wed, 18 Nov 2026 23:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044622;
	bh=APziOsEBxMfPsWqbMzKyOiX8laPNnr2Zqvm8xgpmgTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FD7HjD/lWOgHAigHZ/6uJY1trqNeNrSGcxZy17Xl0oxxqw+vszk4AwfUK+yy9CK9l
	 +DWzRhW3ZCLGR450dJLwtGqSrbcSAgppmOUk7E3+8E9rX6kHJXp0W0K67qNh/68FiK
	 cmCjarJ4L8/G+EKuawBnU1a3pDbVI7FZyV+OpYco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.1 0634/2857] HID: cougar: reject short special-key reports
Date: Wed, 18 Nov 2026 15:27:48 +0100
Message-ID: <20261118150224.333385604@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Jiale Yao <yaojiale02@163.com>

commit c6c0df8a4b73a0d563c5e64de640ef5ff525fc82 upstream.

The HID core invokes raw_event callbacks before validating the report
length.  cougar_raw_event() reads the key code and action from offsets one
and two without checking that those bytes are present.  A short report on
the special interface can therefore cause an out-of-bounds read.

Consume reports that do not contain the action field before accessing the
fixed offsets, consistent with the callback's handling of other reports on
the special interface.

Commit 47669bec44fe ("HID: asus: refactor the two workqueues and init
sequence") added the same kind of raw_event length validation to hid-asus.

Fixes: b8e759b8f6da ("HID: cougar: Add support for the Cougar 500k Gaming Keyboard")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-cougar.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/hid/hid-cougar.c
+++ b/drivers/hid/hid-cougar.c
@@ -270,6 +270,9 @@ static int cougar_raw_event(struct hid_d
 	if (!shared->enabled || !shared->input)
 		return -EPERM;
 
+	if (size <= COUGAR_FIELD_ACTION)
+		return -EPERM;
+
 	code = data[COUGAR_FIELD_CODE];
 	action = data[COUGAR_FIELD_ACTION];
 	for (i = 0; cougar_mapping[i][0]; i++) {


