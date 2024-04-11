Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB8E63A2;
	Thu, 11 Apr 2024 10:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832445; cv=none; b=bJKI87JzQp006MABHegbmeA91qe4QYhzhzwzKjf5wjKj/cqZ+f25iglFwzu8VkVfPJZxcaD/JszZUWQVoTMv2MtzNFp8PW5iRAvlnpcEZLaHyeKqg39C0xUaLZY2tScxomOeE4gyE/i35zotaMfrlSAB30lGGBhCYi7cAygHz9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832445; c=relaxed/simple;
	bh=1E1TPf9LU20y0Laq2mzMSxLGK3/hELJWYO0VaX6f5yg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jf7DVx0ldQUtzh6anHtsFdig4drTVLV24KjTfFdXPGYY6BX6kTjuu1elkfMPjXD9IQJT6tgFD7f5+5ZzFumTpBYHQqJ/S2csibkHqS2O/7015KlMhxOgreSmKrpy7mGMSdwjXKdSXoWzJMNoan41R2Cr/gpVN8lnfxYSPWVUrWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SndFBxyL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SndFBxyL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B926C433F1;
	Thu, 11 Apr 2024 10:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832445;
	bh=1E1TPf9LU20y0Laq2mzMSxLGK3/hELJWYO0VaX6f5yg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SndFBxyLEpWXxOwJWjBxO5eU91uNdYvqgUnk+0Wk5W63Sbs+XYPKTjmK0SU421yNX
	 2i31UEEigkPwQ4hjljabSA9d6WBKJFXwPShJLv8p4uOQYouZvKxjYaM3sHqlOW/ZOT
	 vBH8l5LhKjEU76C0csqQemxDEwtqIjVaWZBa4SXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gergo Koteles <soyer@irl.hu>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 52/83] Input: allocate keycode for Display refresh rate toggle
Date: Thu, 11 Apr 2024 11:57:24 +0200
Message-ID: <20240411095414.250208514@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095412.671665933@linuxfoundation.org>
References: <20240411095412.671665933@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gergo Koteles <soyer@irl.hu>

[ Upstream commit cfeb98b95fff25c442f78a6f616c627bc48a26b7 ]

Newer Lenovo Yogas and Legions with 60Hz/90Hz displays send a wmi event
when Fn + R is pressed. This is intended for use to switch between the
two refresh rates.

Allocate a new KEY_REFRESH_RATE_TOGGLE keycode for it.

Signed-off-by: Gergo Koteles <soyer@irl.hu>
Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Link: https://lore.kernel.org/r/15a5d08c84cf4d7b820de34ebbcf8ae2502fb3ca.1710065750.git.soyer@irl.hu
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/input-event-codes.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/input-event-codes.h b/include/uapi/linux/input-event-codes.h
index 7ad931a329706..1ce8a91349e9f 100644
--- a/include/uapi/linux/input-event-codes.h
+++ b/include/uapi/linux/input-event-codes.h
@@ -602,6 +602,7 @@
 
 #define KEY_ALS_TOGGLE		0x230	/* Ambient light sensor */
 #define KEY_ROTATE_LOCK_TOGGLE	0x231	/* Display rotation lock */
+#define KEY_REFRESH_RATE_TOGGLE	0x232	/* Display refresh rate toggle */
 
 #define KEY_BUTTONCONFIG		0x240	/* AL Button Configuration */
 #define KEY_TASKMANAGER		0x241	/* AL Task/Project Manager */
-- 
2.43.0



