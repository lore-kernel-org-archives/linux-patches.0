Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5848A431488;
	Thu, 30 Jul 2026 14:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421790; cv=none; b=QnzNp9xwvCN2w7Ud+/tAbYfvvaloS50K1oJ7+RsXDQV1H03V2EvhG+yZNtJ5Op0WNJwXyl9NdBF/hpv+57XAaMUCl78tBqkCkrCPbIeQwb2iSEO9s0AaliExPqtvvCyZvTIKYi0Aob6/a9SEvZ0bMZZF3G3TqjKAS4VbOWlPCn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421790; c=relaxed/simple;
	bh=F6Z5csm4sEEtEETX9SIPb+AmYcIMZsaUliso4rtCA9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uxxCMWb7av/IzFYpeF8F/fcXbBI5jcaoFu6ZJzzJxHI5A/1PnAcRmpOMdd9NRG/PRlIQVjGVvTNkFMVoQ6eOZ9F4Tt1ADqzjsWixrG5BaP09141cbGEgp/DRIUobqae5FalREfM9sJAB2sA1iq7rt1cVylbHfFjHuR3Ku2H49bE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PRFkL1Mq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PRFkL1Mq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95CA91F000E9;
	Thu, 30 Jul 2026 14:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421789;
	bh=pR02egyUKk7ZQlzDFssVvSVc0dvKhALMVu7bdnL2+u4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PRFkL1MqM1AQ3Uy0EpeKTpCGa11/ywop7KlK4JNBL63MitUi4Ap5Lq81DF7DjOE3m
	 E3kNG/pJKKALWpMMEv/fqVyzb4991aihlYSHaGwjkqUPAKU2OE/7N6n+LdKG1iLNIN
	 U0rpd/9J4bKBbqsGuV/fE+b9LR7uLA6Rimi6JuHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eugene Shalygin <eugene.shalygin@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 219/744] hwmon: (asus-ec-sensors) add missed handle for ENOMEM
Date: Thu, 30 Jul 2026 16:08:12 +0200
Message-ID: <20260730141448.939461973@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eugene Shalygin <eugene.shalygin@gmail.com>

[ Upstream commit 9813c1f49efeadbcb17e4a41972350ac783f9cac ]

Add missing return value check in the setup function.

Fixes: d0ddfd241e57 ("hwmon: (asus-ec-sensors) add driver for ASUS EC")
Signed-off-by: Eugene Shalygin <eugene.shalygin@gmail.com>
Link: https://lore.kernel.org/r/20260712130602.1256700-2-eugene.shalygin@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/asus-ec-sensors.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/asus-ec-sensors.c b/drivers/hwmon/asus-ec-sensors.c
index 181fbb9511794c..7c281c6005ec62 100644
--- a/drivers/hwmon/asus-ec-sensors.c
+++ b/drivers/hwmon/asus-ec-sensors.c
@@ -1460,9 +1460,11 @@ static int asus_ec_probe(struct platform_device *pdev)
 		if (!nr_count[type])
 			continue;
 
-		asus_ec_hwmon_add_chan_info(asus_ec_hwmon_chan, dev,
-					     nr_count[type], type,
-					     hwmon_attributes[type]);
+		status = asus_ec_hwmon_add_chan_info(asus_ec_hwmon_chan, dev,
+						     nr_count[type], type,
+						     hwmon_attributes[type]);
+		if (status)
+			return status;
 		*ptr_asus_ec_ci++ = asus_ec_hwmon_chan++;
 	}
 
-- 
2.53.0



