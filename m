Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705761;
	b=ntsEtMVf0T+E2KvqXcKyMa2tg8JjH6kHYRzNzld0IDdoSERNG0FOs8eBKUd2u84g95hM
	 8upaWStkToLErK3DHD6HmHxHK6TRD2D8SYRJogbQb6U3JLq5F2tGwmgDDVNgvKurBIeNb
	 OEzt1pxU+m7Z61V+BSH1KzWoEbiG26Oe0fSo4DC29OCmmBzDhkoqRTPpownH2j0kh9aFv
	 YspDg702eLfGG7BRL4Njf0R6FCID3K0mvKMj1wwjXMffsvgT8Cz0evHw+7u4KDAYJXl25
	 ZCHgPbQppeFGFDe6U4QDlqq1iGBZvKx7ZnfOK9qFopDVNrLdAZ5/n3jdDfxtGLgmq4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705761;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WeE/gybHz41+yNs5/E2jgADYmZ0ukrqFGd3SnVSF9xM=;
	b=l0Qtdq1nsrvIiCdGdylDptANXlIAYKE+0s36dHPe0LjrbOUeaC4pPoGKlwxfXNUfn7Gi
	 8knCV5SjI+FJe3e01FFwWkWF9H0eAf5JjOPc3AH5yIhXkm7JkIPG9UHsb5yIzlV9yqlYS
	 CASCzZIzHE2lhV3HrWuC27wh+2R9/cX0dZcwCosjpUVXC8biaoH6/GZMZhpAbBvykCnDV
	 MyG/yoChc0f09DEkNDTCvyMccCV9aeB741rhGJ5eSqCCKhtieUrjoQV6F6M+eTV5eBIVb
	 T1FLS2YQbb5Z7XTMHe74Tp1x+3dWezFiTQ3QkSeIvMO8vj/QzztoVdwZOkVoD1k/zMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nNzW+X8f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815E6606A32C;
	Thu, 26 Nov 2026 15:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nNzW+X8f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AB771F000D2;
	Thu, 26 Nov 2026 15:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705761;
	bh=WeE/gybHz41+yNs5/E2jgADYmZ0ukrqFGd3SnVSF9xM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nNzW+X8fe2KojHT+lS6rn0hLaw5QNNQRo3IT7B6Kvwr7lFTRMlsmH5mRMXEpae7rU
	 d0V+DlowMpNirZzWI6ZU6hVDGZ9qXCc4iHTzOjahmivUsO1w6MqOtriX7ns+6u4+b1
	 mZOGvkTsH11vfZ49IjoqSW3KQLgSCJuOJR1cdGPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 5.15 305/319] iio: imu: kmx61: reject duplicate event disable
Date: Thu, 26 Nov 2026 15:41:13 +0100
Message-ID: <20261126144013.641687733@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -946,7 +946,7 @@ static int kmx61_write_event_config(stru
 	struct kmx61_data *data = kmx61_get_data(indio_dev);
 	int ret = 0;
 
-	if (state && data->ev_enable_state)
+	if (state == data->ev_enable_state)
 		return 0;
 
 	mutex_lock(&data->lock);


