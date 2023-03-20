Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E7641C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:01:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DC1DC433EF;
	Mon, 20 Mar 2023 15:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679324472;
	bh=Z4JTILjU2Zf4BHvFwWSwlXkigBGOcflRlHHkMBh2PxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=09eiqyOI6bkikB81SFbNAnhKksx4C+nzbk3TqZbMnAqyofwtHnQyPwWgSTML9VeiM
	 9lyNfaWSoe8OxBHU7n/g9b+gOuzJ7kKV8ixP41vBUY39Ni2zVkaJ6JEN0yWgTEQntf
	 FDWK2iZEdZnxmhmxzcAjZYUfcbSKV3ABDqnJHbFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcus Folkesson <marcus.folkesson@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 35/60] hwmon: (ina3221) return prober error code
Date: Mon, 20 Mar 2023 15:54:44 +0100
Message-Id: <20230320145432.387710055@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145430.861072439@linuxfoundation.org>
References: <20230320145430.861072439@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marcus Folkesson <marcus.folkesson@gmail.com>

[ Upstream commit c93f5e2ab53243b17febabb9422a697017d3d49a ]

ret is set to 0 which do not indicate an error.
Return -EINVAL instead.

Fixes: a9e9dd9c6de5 ("hwmon: (ina3221) Read channel input source info from DT")
Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>
Link: https://lore.kernel.org/r/20230310075035.246083-1-marcus.folkesson@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/ina3221.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/ina3221.c b/drivers/hwmon/ina3221.c
index 026f70d7c5a43..1b7f92f23530c 100644
--- a/drivers/hwmon/ina3221.c
+++ b/drivers/hwmon/ina3221.c
@@ -672,7 +672,7 @@ static int ina3221_probe_child_from_dt(struct device *dev,
 		return ret;
 	} else if (val > INA3221_CHANNEL3) {
 		dev_err(dev, "invalid reg %d of %pOFn\n", val, child);
-		return ret;
+		return -EINVAL;
 	}
 
 	input = &ina->inputs[val];
-- 
2.39.2



