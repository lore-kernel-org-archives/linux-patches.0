Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063494;
	b=5pewq97fozJoz/WWeJtSxZEw5yvDtKYddCdxGNiy25b14L5kxdu1aFW4A4pV15onEeSn
	 ayPlulIT6hQBIMimCokbdnYhHtYGL7KsP+VvvdI4uSb8CBZvrWjQpwbKN48OKdEKtTnBy
	 FlDjDLPwTlpThoP0trHLjBzfPAMfP1s0w8LBSAlAYjxHQOo+7rByTU88MqMH2yFv5e0Q3
	 KKJl3EtOv1ZhKmd7vzHRL0iqq2dGB9RpJ6QTgKDGLCi3n3Dl38/ljCSTsAtgl7o2/hIGi
	 xDar45XltiXaTZKHmTqYGUXMs+FDypbl5HBfXLRFVazViJEeqT3oa/5oYlf2glxnBAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063494;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/wB83PgTxmnWQ0SLXRqctgvs7oAQtEJYLv9RNNHly68=;
	b=3YnotDd5joL1prr4UiQELf1Y2Mn3TAI3l1vB5p//H5wqXDzVVEiOPU6zO0Qx7XiKkYa4
	 f+DKhPaTBrB5tjjkbNnWBQUvlPHUKl51R8lew+Cz2cqwqo6FLBM15SVUykhvFKYhD9hQr
	 aGmCs2FsThSLwCN2O2gQ1GcQuboW+nT/SvP1qJKguawHmgGBgHkJOLi3YvjxpVRVmnaAV
	 ris/AgJ9T/vp2Acizgki9dbIJSG1ONi4y0n29FVKgWHlUy0tw0NxUPqEz6NX0E8XuHdqF
	 DGss35Dm3GoJOcMpbBxJ/dG38GHc+vR1sNNanQOFcSc6MHBklVJk3NAH6fx+K5oW71w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uWy1ICrR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C3AD606B894;
	Sat,  7 Nov 2026 14:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uWy1ICrR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF21F1F008A2;
	Sat,  7 Nov 2026 14:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063494;
	bh=/wB83PgTxmnWQ0SLXRqctgvs7oAQtEJYLv9RNNHly68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uWy1ICrRXDrHxisaqMEVfKQnYzPyutNuGT3XXloZMzHpdlZ77v8wB6opYP1q+lpQY
	 Fl25O7bnYr3jofhGtbAQrNsyaYJO75+znpTII7gW/oS9R4uDKqbBF14ulRkKDnkZlo
	 AYJkB1ObLFwS8pwtZCHD7zvr+ULISoio4XEkq7SI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Baek Kyu, Kim" <pocj8ur4in@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 638/869] hwmon: (sht4x) Reject incomplete heater command transfers
Date: Sat,  7 Nov 2026 08:55:20 -0500
Message-ID: <20261107134914.566031894@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baek Kyu, Kim <pocj8ur4in@gmail.com>

[ Upstream commit 0e1d292233c83d41530df6ffa4ec5a382f118b12 ]

heater_enable_store() treats a zero return from i2c_master_send() as
success. It updates the heater state and returns count, so another
attempt to enable the heater fails with -EBUSY.

i2c-virtio can return zero when the first message fails. Require
SHT4X_CMD_LEN before updating the heater state, as sht4x_probe()
already does for the reset command.

Fixes: 0eed6fc3d2b9 ("hwmon: (sht4x): add heater support")
Cc: stable@vger.kernel.org
Signed-off-by: Baek Kyu, Kim <pocj8ur4in@gmail.com>
Link: https://patch.msgid.link/20261017205234.1084949-1-pocj8ur4in@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/sht4x.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hwmon/sht4x.c b/drivers/hwmon/sht4x.c
index f757265a82a6d..83dc3ca67046b 100644
--- a/drivers/hwmon/sht4x.c
+++ b/drivers/hwmon/sht4x.c
@@ -287,6 +287,8 @@ static ssize_t heater_enable_store(struct device *dev,
 	ret = i2c_master_send(data->client, &cmd, SHT4X_CMD_LEN);
 	if (ret < 0)
 		return ret;
+	if (ret != SHT4X_CMD_LEN)
+		return -EIO;
 
 	data->heating_complete = get_jiffies_64() + msecs_to_jiffies(heating_time_bound);
 	data->data_pending = true;
-- 
2.53.0



