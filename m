Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043414;
	b=s9d4oOpZkBMLcRLla8PhxPSN1FF29tLTOFpTwv6WJhW1ezn+dBOsrrYo1h7wj/AZcq/9
	 znpvewVQP5Q+rqtj0kcEbJbw3+Oadv5ejyIrPc7A+0cUbCQwWNO9gJWNSwPi/ASCyhIh9
	 zbwgTg1m/loew6iW9Ymk5tVx415191VOvfITfdOn1jAB+ZwaZyiGmOxmdyYkn/QOlJ4l8
	 FxJTlxZT7EqJqlTCYUbQhx54UUok2uRmXyMWh5rxApeqodPdqphlKgBWFpMdOgsAJd0aE
	 PLPH55B5Wwpf6ghYshad0x0GX5j0TaxUVoIHhq8720f2l9IA4a44Xo3QOnwD2+3TwtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043414;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=STUB0uqCQbFUEd88gwEYnPd856UaJs535dmQv6Eio+A=;
	b=PUpp5GVozQBCgYz7mBw9mPGCz13bUuPYCjZ6nwU9fuowDmzN0iJDIz3m9jRy9lPYiddm
	 qfIDvP2rpGXaM+MSZT/h7FjNvdHUFz8WJ8TuPKnA+FiQSeRGVc6mOyUf3HOCMmGAHqxiy
	 yTTVn3CsL7LvVRHKWW0P1Adi7vHkXohSDBju9BCHvLKBBpnnsZnJhBT9ppASzCce8RT+K
	 7NIlG0LDutM/hdH6D6A0u+pLxymPTkPZCKxL6HK5+zuDvC7GNkhoo7wWQmJLMDLyK7XzS
	 otAES2eH+551L4WOzttdj/faizngy2ARRfSjpVB5U+OTHFmd1Q8j71RCnRrJCPtUxZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RuZGSki8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B88EB606A330;
	Wed, 18 Nov 2026 23:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RuZGSki8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D70601F000D0;
	Wed, 18 Nov 2026 23:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043414;
	bh=STUB0uqCQbFUEd88gwEYnPd856UaJs535dmQv6Eio+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RuZGSki8pDOm1bSNgnlmwwS3GD/R6bGK6QO3SkWLFfyEr8ZzwVzAYZpegOotnpo83
	 hIwWABYaDwQ4aLWdbIwjZ5KMCaytgG5KLvDofSg0dNuEPqR/8tS1IUEHzjMcIyiH94
	 DlLIV2+Sm++9gVgCV+Yyq7wAADe0gmIjXc2+XnCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0203/2857] HID: rmi: check report length before trimming sentinel bytes
Date: Wed, 18 Nov 2026 15:20:37 +0100
Message-ID: <20261118150208.660486142@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 28a3e326fad2451bdb66b747dd1f7ccbb900eed6 ]

rmi_check_sanity() trims trailing 0xff sentinel bytes, but its loop
reads data[valid_size - 1] before checking that valid_size is non-zero.

Reverse the condition so the length is proved before the last byte is
inspected.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-rmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-rmi.c b/drivers/hid/hid-rmi.c
index 8788192c09561..cd3173af5d7bf 100644
--- a/drivers/hid/hid-rmi.c
+++ b/drivers/hid/hid-rmi.c
@@ -386,7 +386,7 @@ static int rmi_check_sanity(struct hid_device *hdev, u8 *data, int size)
 	 * such reports here.
 	 */
 
-	while ((data[valid_size - 1] == 0xff) && valid_size > 0)
+	while (valid_size > 0 && data[valid_size - 1] == 0xff)
 		valid_size--;
 
 	return valid_size;
-- 
2.53.0



