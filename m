Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041355;
	b=5VhhMp/tmf90wKlLreIPfUh3UXgVeeQtH63Tf0o+1+Nv8EHodfH2BiMsIfLpXYP2b5Js
	 GUN9IwjJo/iMpCtT0p7q4sG8oaZ0+IKrPsq6P+/5JGijM/+9NImhBOZ+Zy9JsbmUJd5Be
	 ROFvba08Vx2uhQRPI8pypFK6l5G1XKcJqN07Wu+6XbXbF7hSpxQW1x7//OCt1S6mHdGnh
	 /4oXZljE82tDtth3HLZpUV2T9YBuzaorL3a69bEyAYGSQ+99hLmSWI2HSJe7d9WAGE7/4
	 MmwzbT8qDqgxRtXb8PNZ5ZW/jmWAL+DTxtL+DkGvYW6rLQiiXDJUQabXYxgtiISU19w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041355;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RmbppKRMsMKMHJHf5huAjuSdv52gH5pUffw/AdP4g7A=;
	b=U7s3hI0ClPRCXEV7AnrqUsrSdq3erQdWNrXwD22pZzwv0ZGu+/Fpt84wFRnwtcXCSt6D
	 xvngAbn8AeO7EolVytNJCwoZplDr1Aoip7uLN6KiUwPbAOmvB8KfzI+ihhOb5vvyGyLa1
	 K4H36A9vtsp75LMahNqLESXfl7H19NP8nW9lkxzAJG7eAxX2nzPMF6Fy7RHjMDG7yvFyX
	 K+k0/TBR1xnMoa85lJa9DwGj3cGM7ZTvm4ZJ0i3hdAXOrMHhqb5kBS5I9OI52lKgp/pjc
	 /934lEVMP0eOs5lkC+elSH/Z1g/f7tVAx4/gPe5PfmFwGTpcF6BnR8yaaeW3Yq2VUmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PIYKkypC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61F2E606A337;
	Wed, 18 Nov 2026 22:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PIYKkypC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8A0D1F000D0;
	Wed, 18 Nov 2026 22:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041355;
	bh=RmbppKRMsMKMHJHf5huAjuSdv52gH5pUffw/AdP4g7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PIYKkypC7CGViDf48mP1rdkMRgsoxKqz3f3oQyntpI8DUYkUEUZDPU+C03Btpwuat
	 dn001c7iwg4pwAFlLsglzAUqovW96tZrOB5HbCdt5XCPC2FZV8cBlA1NWFFP33ITNk
	 cTPqgh5kZOwA9D8QTh5s3bEBX+5iWsfF0VN+MZqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2784/3318] serial: max310x: remove holes in struct max310x_devtype
Date: Wed, 18 Nov 2026 15:56:46 +0100
Message-ID: <20261118150444.215180828@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

[ Upstream commit eaf29135abb1c152a05572a5454c61dcd65bdeea ]

Running pahole shows that there are some holes within the
max310x_devtype structure.

Remove holes and optimize alignment by reorganizing structure members.

This can also lead to data structure size reduction for some CPUs.

On 64-bit CPU (arm64):
Before:
    /* size: 40, cachelines: 1, members: 6 */
    /* sum members: 34, holes: 2, sum holes: 6 */
    /* last cacheline: 40 bytes */
After:
    /* size: 40, cachelines: 1, members: 6 */
    /* padding: 6 */
    /* last cacheline: 40 bytes */

On 32-bit CPU (i386):
Before:
    /* size: 32, cachelines: 1, members: 6 */
    /* sum members: 26, holes: 2, sum holes: 6 */
    /* last cacheline: 32 bytes */
After:
    /* size: 24, cachelines: 1, members: 8 */
    /* padding: 2 */
    /* last cacheline: 24 bytes */

Suggested-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://lore.kernel.org/r/20240118152213.2644269-7-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 4efacb600bf9 ("serial: max310x: fix breaks not reaching the wire in RS485 mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/max310x.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/max310x.c b/drivers/tty/serial/max310x.c
index 4efa33b9c52c9..123a81976ee8f 100644
--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -268,11 +268,11 @@ struct max310x_devtype {
 		unsigned short min;
 		unsigned short max;
 	} slave_addr;
-	char	name[9];
 	int	nr;
-	u8	mode1;
 	int	(*detect)(struct device *);
 	void	(*power)(struct uart_port *, int);
+	char	name[9];
+	u8	mode1;
 };
 
 struct max310x_one {
-- 
2.53.0



