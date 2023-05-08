Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 223D4168C5
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:53:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 849E7C433D2;
	Mon,  8 May 2023 10:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683543235;
	bh=FCO+mQ7M3QwYjQeEpbF4qYkU0s0b3eMBg1HLdPwqYy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=voRMgSoksqKr0Kd7VgEjf6JcoNHI2HdOKXsUQVW6Tria9hyXjt+q3YE4W+Ib7mZND
	 8MTR4fQB9DVEoLNIaHkQuIqQI8Nw+dEYSxJbKhqqpN5/A31663GIqBnIp5YN31HPPR
	 aa4/S14PUgWia5GhkjviX02DmNheJntrBxTh5s4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>
Subject: [PATCH 6.3 026/694] staging: iio: resolver: ads1210: fix config mode
Date: Mon,  8 May 2023 11:37:41 +0200
Message-Id: <20230508094433.485196542@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nuno Sá <nuno.sa@analog.com>

commit 16313403d873ff17a587818b61f84c8cb4971cef upstream.

As stated in the device datasheet [1], bits a0 and a1 have to be set to
1 for the configuration mode.

[1]: https://www.analog.com/media/en/technical-documentation/data-sheets/ad2s1210.pdf

Fixes: b19e9ad5e2cb9 ("staging:iio:resolver:ad2s1210 general driver cleanup")
Cc: stable <stable@kernel.org>
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20230327145414.1505537-1-nuno.sa@analog.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/iio/resolver/ad2s1210.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/iio/resolver/ad2s1210.c
+++ b/drivers/staging/iio/resolver/ad2s1210.c
@@ -101,7 +101,7 @@ struct ad2s1210_state {
 static const int ad2s1210_mode_vals[4][2] = {
 	[MOD_POS] = { 0, 0 },
 	[MOD_VEL] = { 0, 1 },
-	[MOD_CONFIG] = { 1, 0 },
+	[MOD_CONFIG] = { 1, 1 },
 };
 
 static inline void ad2s1210_set_mode(enum ad2s1210_mode mode,


