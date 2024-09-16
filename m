Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECB101547FF;
	Mon, 16 Sep 2024 12:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488032; cv=none; b=g04NSlb+s4SBmn2Bm7YFYsOooWJQ5qYF8lZB2hpQT9XSrRIIaA0c+SmBEvSoGa7ILMh/OB9iUgNwKrdKv6cg8MH4tdqxBEIZbJQaIRSdBbwJLcUDGHX/9BgX5rJrVhfYp9cIcOIeHCy+SS+pI3aZSlYTIV0IS7UXkPXongoYFFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488032; c=relaxed/simple;
	bh=4IR5LjgKmFL7IuEavhVQRmIt2zN9mwgi06NQKfoQn9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qd80Re/LecYgIRtZmLWI0lGLqPqLTG2wSmXi4vXzrHKp/bp5sJ7DOv01kyxMrhlYSPp9fju3KO8WYDEjf9JhLHq+2ZQMZaXJqJovUn9e6VD2SbBWmqPeS6B7RKZaCGQxj+PgbLYG+0rNamvpMlQtnRua6bMAPtKzbwtyT91zaPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=erfkpmaV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="erfkpmaV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A001C4CEC4;
	Mon, 16 Sep 2024 12:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488031;
	bh=4IR5LjgKmFL7IuEavhVQRmIt2zN9mwgi06NQKfoQn9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=erfkpmaVed/nQiUS0BRvNbU6zX8UAcvCInJ8AsXu7edcCzSjXPDslMYDzFM9ClUd5
	 BFS3kK34b13NHuDHlGFSyTxfA9q4jU3cPVaNW5kKTY/rftXJ6cBuZJZr+87QdgT6Gm
	 XE8gN9tCgV4nAjDq30fJGvH5GKnmYRvOe7TM3TM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 34/63] eeprom: digsy_mtc: Fix 93xx46 driver probe failure
Date: Mon, 16 Sep 2024 13:44:13 +0200
Message-ID: <20240916114222.275533975@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114221.021192667@linuxfoundation.org>
References: <20240916114221.021192667@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 2b82641ad0620b2d71dc05024b20f82db7e1c0b6 ]

The update to support other (bigger) types of EEPROMs broke
the driver loading due to removal of the default size.

Fix this by adding the respective (new) flag to the platform data.

Fixes: 14374fbb3f06 ("misc: eeprom_93xx46: Add new 93c56 and 93c66 compatible strings")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20240508184905.2102633-3-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/eeprom/digsy_mtc_eeprom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/eeprom/digsy_mtc_eeprom.c b/drivers/misc/eeprom/digsy_mtc_eeprom.c
index f1f766b70965..4eddc5ba1af9 100644
--- a/drivers/misc/eeprom/digsy_mtc_eeprom.c
+++ b/drivers/misc/eeprom/digsy_mtc_eeprom.c
@@ -42,7 +42,7 @@ static void digsy_mtc_op_finish(void *p)
 }
 
 struct eeprom_93xx46_platform_data digsy_mtc_eeprom_data = {
-	.flags		= EE_ADDR8,
+	.flags		= EE_ADDR8 | EE_SIZE1K,
 	.prepare	= digsy_mtc_op_prepare,
 	.finish		= digsy_mtc_op_finish,
 };
-- 
2.43.0



