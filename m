Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5154E188A3A;
	Thu,  3 Apr 2025 15:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743693980; cv=none; b=vGFXAYv+Ip4Em7Cx9rC/8A72/Uzf35A5ivXaJ4yunnV+RTb0U14A0UX9FjOeJ+v332VW1ZtfFTV7qEmRSMyaGde/TypksUt3UxH2in1QBwCpUsI93n7XqEjvDyo00GxAAxFwT3OI3BHkQzDtv7Bd7DKF3QlwIN9vUhn+80B5mjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743693980; c=relaxed/simple;
	bh=ODYUxrQVdg4xRnAjQSrv8gU+Alvc6uHp7RJfKehKFDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gXjJxNd9VZZfA7zLj0OzbqALt6InNbgiK5hPUC8cUEIowxBpGdLZVwWVtoLTFHkyxkZbbEq8YbEcIt+JxpsaQKdYD4RjkmHPN1CFNN5P8NhvhSp8PPc4LEPLFWtwz2P6SwDPa1uRkVPay16V1ya6JN+/Ofrm8Uf9HavAJGDD4ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IJaahZlN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IJaahZlN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD20FC4CEE3;
	Thu,  3 Apr 2025 15:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1743693980;
	bh=ODYUxrQVdg4xRnAjQSrv8gU+Alvc6uHp7RJfKehKFDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IJaahZlNir/JZLT/Spj6xQxgJoMnJgAF5mP3LS7VzsCqCvzbc3fLv92BiOWEJAj/C
	 9wFVxDMFGPW9v6ELSL6FedfgldTVGZAcZq8G4WrAOIGqHMeZR2ZNNolaHh2jwkPAyA
	 FxftSGWqOo3d61M70uoe1Ue4ivVvGZC4B6zAfkhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Changhuang Liang <changhuang.liang@starfivetech.com>,
	Hal Feng <hal.feng@starfivetech.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Jianqi Ren <jianqi.ren.cn@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 6.6 12/26] reset: starfive: jh71x0: Fix accessing the empty member on JH7110 SoC
Date: Thu,  3 Apr 2025 16:20:33 +0100
Message-ID: <20250403151622.771696143@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250403151622.415201055@linuxfoundation.org>
References: <20250403151622.415201055@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Changhuang Liang <changhuang.liang@starfivetech.com>

commit 2cf59663660799ce16f4dfbed97cdceac7a7fa11 upstream.

data->asserted will be NULL on JH7110 SoC since commit 82327b127d41
("reset: starfive: Add StarFive JH7110 reset driver") was added. Add
the judgment condition to avoid errors when calling reset_control_status
on JH7110 SoC.

Fixes: 82327b127d41 ("reset: starfive: Add StarFive JH7110 reset driver")
Signed-off-by: Changhuang Liang <changhuang.liang@starfivetech.com>
Acked-by: Hal Feng <hal.feng@starfivetech.com>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Link: https://lore.kernel.org/r/20240925112442.1732416-1-changhuang.liang@starfivetech.com
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/reset/starfive/reset-starfive-jh71x0.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/reset/starfive/reset-starfive-jh71x0.c
+++ b/drivers/reset/starfive/reset-starfive-jh71x0.c
@@ -94,6 +94,9 @@ static int jh71x0_reset_status(struct re
 	void __iomem *reg_status = data->status + offset * sizeof(u32);
 	u32 value = readl(reg_status);
 
+	if (!data->asserted)
+		return !(value & mask);
+
 	return !((value ^ data->asserted[offset]) & mask);
 }
 


