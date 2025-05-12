Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8898C78F52;
	Mon, 12 May 2025 17:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071039; cv=none; b=m2eayhyUco87uOjLVqQJ5hI2dYonlOWHoNuqun+H1ByS8byw3yIyhKaAw/XP3ZOXk7+nFyU+/46subVvr5sAhF81qVumfsuuCyPQSAikxlGEa78KtMlKfLzhjSh3UmA9neFPPMgaFFYG2dOJCppul9DEv3ULit5VYnp1nl1kPpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071039; c=relaxed/simple;
	bh=L8IW/3w3HQ2TaBeeCcWB0JvuXsda+IW6VSz2NPjwNa4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Af8e4o0j+99HiNj7zFMFf1jLEPC735CA53R8UtWmLaSqBDjrwoANMp5kyPAGI84WpTYr3GJDkfQluMzctM3ZnL4kO5xmQ0zTjIc4PPP0LQy7yaxudLu0qCbWS1OADOcBjlGc5OF13OMYtrmDXg5xPaozo/bKD9wjbMYNZHu2/6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sYfqBs5u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sYfqBs5u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A72E3C4CEE7;
	Mon, 12 May 2025 17:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071039;
	bh=L8IW/3w3HQ2TaBeeCcWB0JvuXsda+IW6VSz2NPjwNa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sYfqBs5u3RqDinMOI8bMoTj3igNgFBBEQHUwORBV6Td52K53BDHp2ZHWpDw9WiBgF
	 lpVwYlbQFNgjIjnw2TAuz74WYoDFJ6US2kk7ZvrnSjn1FNmLar29UH94LjevIkKoNa
	 nIUp4DKUu4/gSQD/F/hN2zkaNiYzN9K+lIRlFl+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Rathgeb <maggu2810@gmail.com>,
	Aditya Garg <gargaditya08@live.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.15 17/54] Input: synaptics - enable InterTouch on Dell Precision M3800
Date: Mon, 12 May 2025 19:29:29 +0200
Message-ID: <20250512172016.343831262@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172015.643809034@linuxfoundation.org>
References: <20250512172015.643809034@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aditya Garg <gargaditya08@live.com>

commit a609cb4cc07aa9ab8f50466622814356c06f2c17 upstream.

Enable InterTouch mode on Dell Precision M3800 by adding "DLL060d" to
the list of SMBus-enabled variants.

Reported-by: Markus Rathgeb <maggu2810@gmail.com>
Signed-off-by: Aditya Garg <gargaditya08@live.com>
Link: https://lore.kernel.org/r/PN3PR01MB959789DD6D574E16141E5DC4B888A@PN3PR01MB9597.INDPRD01.PROD.OUTLOOK.COM
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/mouse/synaptics.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -163,6 +163,7 @@ static const char * const topbuttonpad_p
 
 static const char * const smbus_pnp_ids[] = {
 	/* all of the topbuttonpad_pnp_ids are valid, we just add some extras */
+	"DLL060d", /* Dell Precision M3800 */
 	"LEN0048", /* X1 Carbon 3 */
 	"LEN0046", /* X250 */
 	"LEN0049", /* Yoga 11e */


