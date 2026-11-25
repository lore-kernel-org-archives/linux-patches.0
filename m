Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620727;
	b=YSBT/YfhiMi8K/2fInGgexBbh0VZC3abiAndDvTrvQyAIziPt/prbG/Il7t2KRnmQ6/P
	 QqS9jgBVVI+tLv8eNKk8hcC8JuL5oJ57ISXWChSzC6Ldfw/GWNc07FZjKccGaTFvoHTEw
	 JIXyoD4TrvJ+cEYT0PTdCutjZRgSyKH1ULJfkjqQkJ0WEH1pYmG+LOfwjTCR11RWWJe7V
	 JkNmHlGbit/jSzAFMmkNlI5NuWFAYp3z8jzhjFVuuKiFZP/h05SgkOdwbtwhqob9XW6gL
	 JOO06p+yNHJaP4/fgeFD5bIgJXz/eFOorhlrXJcqvYayPmbU7eJxHDnhjuCLwkSM8Kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620727;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=S/DuZsO9oKvFuxNoW+N7iQ7kTu5xWJkmOJoqlksl88g=;
	b=I3p4lWubknw40IP0CGcSiD6rduOxSWD5Wew8pt9VHP+LVZA8tnZYQkOSptLfop5B/hdx
	 QCnHHmRFQpXhZBNptMr+gmww+DAZLLjfSS0JOcuHQlumZa/K3psGVwxecoIrs9u7ZWWuv
	 /paBkMaYrTXKACh6TefvtNAxM1umP75Hxl8JwXzdevYiVPjXZe37x0FqAOcgg2NUX+clZ
	 VZgWS1gQygr2CbJ5q+lyW8GaPRH/OoBjhdlqmkpmiH6bp1p5I5FBcpa6csAaSItF6BJ3L
	 zG9u2zV5Mmf576uFgFmS3ptuJcDD1lFePsaeYsMuxiHbiPRIxJ0jB1mnKqcFRWSxklw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J+QBTuyH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CBDE606A321;
	Wed, 25 Nov 2026 15:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J+QBTuyH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4315E1F000CF;
	Wed, 25 Nov 2026 15:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620726;
	bh=S/DuZsO9oKvFuxNoW+N7iQ7kTu5xWJkmOJoqlksl88g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J+QBTuyHiYA/0/Zd6hjdBa/pCNkVxftmwrOOiujM87q9hMJfUTqkbrv89sx/bTaUh
	 DwLaHHKiYXOQ9V3BtIkvymblxMOpXa9oDu17SiHVg4ElRp3aeR8qV9kkICtAmqOk2Q
	 tSgnJRNPmZFgMyjSewmpnTtR7otk+BWl+S32AJp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.3 0980/1005] iio: imu: kmx61: reject duplicate event disable
Date: Wed, 25 Nov 2026 15:38:38 +0100
Message-ID: <20261125143844.617923939@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

commit 9a60b35fe45801d45454e1efe90569c9cc6ea736 upstream.

The IIO core does not filter duplicate writes to the event enable
attribute. kmx61_write_event_config() already ignores repeated enable
requests, but a repeated disable request still calls
kmx61_set_power_state(data, false, KMX61_ACC), dropping a runtime PM
reference that was not acquired for this request. This can underflow the
runtime PM usage count and trigger a "Runtime PM usage count underflow"
warning.

Return early when the requested state already matches ev_enable_state.

Fixes: fd3ae7a9f21c ("iio: imu: kmx61: Add support for any motion trigger")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/kmx61.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/imu/kmx61.c
+++ b/drivers/iio/imu/kmx61.c
@@ -939,7 +939,7 @@ static int kmx61_write_event_config(stru
 	struct kmx61_data *data = kmx61_get_data(indio_dev);
 	int ret = 0;
 
-	if (state && data->ev_enable_state)
+	if (state == data->ev_enable_state)
 		return 0;
 
 	guard(mutex)(&data->lock);


