Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC8CF28365
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fEm5+mRH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59FFEC433C7;
	Wed, 15 Nov 2023 19:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076656;
	bh=NAGc+pNhajpm72NMqKGehmBpDTaTjaYYuGwL6Yw1dXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fEm5+mRHkcmxhVo/vnSrtsgnWLkQswTHDv+6xtdsmU+Y+talnenOA2+c/J4A+QsGK
	 rq9NYP4Nk9EeonZUHOVL4sneVAyTNkUxq1MkPCHmifmaobl7TSX4Rm6fKvffCjIC3j
	 yi+FYDX/d9V5K+H960h2fB/CtcwpURyGAmHF074s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 366/550] mfd: core: Un-constify mfd_cell.of_reg
Date: Wed, 15 Nov 2023 14:15:50 -0500
Message-ID: <20231115191626.190295581@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michał Mirosław <mirq-linux@rere.qmqm.pl>

[ Upstream commit 3c70342f1f0045dc827bb2f02d814ce31e0e0d05 ]

Enable dynamically filling in the whole mfd_cell structure. All other
fields already allow that.

Fixes: 466a62d7642f ("mfd: core: Make a best effort attempt to match devices with the correct of_nodes")
Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Link: https://lore.kernel.org/r/b73fe4bc4bd6ba1af90940a640ed65fe254c0408.1693253717.git.mirq-linux@rere.qmqm.pl
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mfd/core.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mfd/core.h b/include/linux/mfd/core.h
index 47e7a3a61ce69..e8bcad641d8c2 100644
--- a/include/linux/mfd/core.h
+++ b/include/linux/mfd/core.h
@@ -92,7 +92,7 @@ struct mfd_cell {
 	 * (above) when matching OF nodes with devices that have identical
 	 * compatible strings
 	 */
-	const u64 of_reg;
+	u64 of_reg;
 
 	/* Set to 'true' to use 'of_reg' (above) - allows for of_reg=0 */
 	bool use_of_reg;
-- 
2.42.0



