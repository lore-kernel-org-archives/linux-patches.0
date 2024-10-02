Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0DAF1CF5FB;
	Wed,  2 Oct 2024 13:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876793; cv=none; b=Ha5U9xo0MbRzEln7c4dydtZFwyM1pdRxIUYDUoc8/rPF0blkiljG6hdnJfRwz9gyq+xIkCLbs34aRKLe7tMHu83iBvoVIbzaExgUcv1fA+fkin22pjSB09dr0TbcI8WCR8MUZZmGLFPX0YRldMqW4h7MohFnYjq+e/Ujdt5kT18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876793; c=relaxed/simple;
	bh=4+KEffUu3bOrTTDO6tuQ0+xbhSc/4SidAi4iQMary3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UU1v0FV9TvUOs+yHrrlfJo2RnbR1cfPb1s+B2vDx1jJPp54aEfP2uHW8VoWlMYBjLJ3+XflJ3hJ55wXAW44WCTCTK+95u8u/0VEqiRcBgBJEJmg4LqQff6QUK7XiuymiEA21CRbJENVgpZAqwGM0jf4lsiG2GmHDFNiXiLg8qS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f7IQ4WO7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f7IQ4WO7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 501B4C4CEC2;
	Wed,  2 Oct 2024 13:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876793;
	bh=4+KEffUu3bOrTTDO6tuQ0+xbhSc/4SidAi4iQMary3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f7IQ4WO74a9V3HNM/ICxoCn4zGVNKyuYs983Ek/uap7WiBZypj/0Q4sbt6/pRR+ms
	 K+2zRmD6O/HiEnf91MVRZT2Q+971Jftg3Wd5I9dtxf5d8dG8Fb3OFbIjPXIpAEdCCd
	 ejoEWaPtcwjAKE7puUxokR92s1TNSiHQa7jODKEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Werner Sembach <wse@tuxedocomputers.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.11 532/695] Input: i8042 - add TUXEDO Stellaris 15 Slim Gen6 AMD to i8042 quirk table
Date: Wed,  2 Oct 2024 14:58:50 +0200
Message-ID: <20241002125843.735330456@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Werner Sembach <wse@tuxedocomputers.com>

commit 3870e2850b56306d1d1e435c5a1ccbccd7c59291 upstream.

The Gen6 devices have the same problem and the same Solution as the Gen5
ones.

Some TongFang barebones have touchpad and/or keyboard issues after
suspend, fixable with nomux + reset + noloop + nopnp. Luckily, none of
them have an external PS/2 port so this can safely be set for all of
them.

I'm not entirely sure if every device listed really needs all four quirks,
but after testing and production use, no negative effects could be
observed when setting all four.

Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240910094008.1601230-3-wse@tuxedocomputers.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/serio/i8042-acpipnpio.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/input/serio/i8042-acpipnpio.h
+++ b/drivers/input/serio/i8042-acpipnpio.h
@@ -1143,6 +1143,13 @@ static const struct dmi_system_id i8042_
 		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
 					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "GMxHGxx"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
+					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
+	},
 	/*
 	 * A lot of modern Clevo barebones have touchpad and/or keyboard issues
 	 * after suspend fixable with nomux + reset + noloop + nopnp. Luckily,


