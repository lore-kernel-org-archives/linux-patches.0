Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA907346E7F;
	Tue, 16 Dec 2025 12:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887610; cv=none; b=aGBCFTPqJROSlu3YQK6KHI9tgrVdKDd9sd7dMfI5TCH77AT4EWMM+bpSOxQ43eSJHp4Jdmm+yR8RAkmZrGKH21/X1wzKXCa1Zc3kr9bccWKAPVRzJ1Z5CqISElXsH8Hpi2jgsqHRi7dl9eSR+tOKVmvgO1XiZ8vrN6bkCwtQxeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887610; c=relaxed/simple;
	bh=8eaf4JWgK2/w/eFqWsZar14kuEN92mwLH2ZP7bGTvaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lM1eYYqu/njI5WF3j+xFiUaaMkS1yGeGkTlEEC8a5Tdr0T1lNlKt7S5aQ+0DJuBjmWY4ykS4yTZf2lHBce2kABDcB51yNej3XczwSvLz6KlDNUeZhOfKN4HiLaldreMbCLtUaEQ/aZCFSM9KMwvDjK2lXBauVzjpoqak6z7NqqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CruFwiyH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CruFwiyH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3752DC4CEF1;
	Tue, 16 Dec 2025 12:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887610;
	bh=8eaf4JWgK2/w/eFqWsZar14kuEN92mwLH2ZP7bGTvaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CruFwiyHxwJm5D9dTfdqaz9us6ynM7MXPG4hliwmRAbbdpGNatVpLi90jRtb2Uxxa
	 Ou0DaNcncv9oJ9CA/CqeF8rJnuXZvKL4yRUfRxd8tSu9yKC3yzCkeM3oNXtpyt+G05
	 UwsNl5zypL7tyZn5OmCBCuYwFhwCtUqnvsKaFbos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 284/614] pwm: Use %u to printf unsigned int pwm_chip::npwm and pwm_chip::id
Date: Tue, 16 Dec 2025 12:10:51 +0100
Message-ID: <20251216111411.662279761@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@baylibre.com>

[ Upstream commit 5f7ff902e7f324c10f2b64c5ba2e5e2d0bc4e07e ]

%u is the right conversion specifier to emit an unsigned int value.

Fixes: 62099abf67a2 ("pwm: Add debugfs interface")
Fixes: 0360a4873372 ("pwm: Mention PWM chip ID in /sys/kernel/debug/pwm")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Link: https://patch.msgid.link/20251006133525.2457171-2-u.kleine-koenig@baylibre.com
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
index 5b75f4a084967..7dd1cf2ba4025 100644
--- a/drivers/pwm/core.c
+++ b/drivers/pwm/core.c
@@ -2696,7 +2696,7 @@ static int pwm_seq_show(struct seq_file *s, void *v)
 {
 	struct pwm_chip *chip = v;
 
-	seq_printf(s, "%s%d: %s/%s, npwm: %d\n",
+	seq_printf(s, "%s%u: %s/%s, npwm: %u\n",
 		   (char *)s->private, chip->id,
 		   pwmchip_parent(chip)->bus ? pwmchip_parent(chip)->bus->name : "no-bus",
 		   dev_name(pwmchip_parent(chip)), chip->npwm);
-- 
2.51.0



