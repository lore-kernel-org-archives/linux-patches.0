Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB75A3B3BFE;
	Fri,  9 Oct 2026 14:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556065; cv=none; b=kjbtLwLr2rGOAjJ3adt8YDb3S3c5SHLETWhYRM2vCNPAQuV17HcD2psZNYnDKomaKcRmFdq+VxaZd3eTs3fUR0z3hKhB0ZoKF9ose6e1QaJcES6aBI3W+1oYbEp6YIkYtiCJcg6ZO9oDDjtLpwDme5+Eh8uJWGKbtCY4YfgME7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556065; c=relaxed/simple;
	bh=weoe4X3+WaBClYf51+IKKEiPIzjWOzm8OOaWjDW1diI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hpdeNBfsZ/WT4JWD5EaoC2wk+7Vj/Xnlz1MtWwhBg87ZlQ/e/l34vyt/DIItQBZHFKsIlO8JeJ5AelCl8Ki9Qufdghva7KRR9cSpvgRKriF3UBP0d8W3JMqe56XcuVS2sz6tdxQ9g0XMoxw6qtHo6V6mT5++o+S+JshrMIVH9Fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SIUq7jjU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SIUq7jjU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFD471F000FF;
	Fri,  9 Oct 2026 14:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556064;
	bh=q8d1Kc6rX7Zb1mSf5MQkdsxilJLd25UDTsJiPU7NDEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SIUq7jjURn/WOtqyGPnqu0GufeFUXBMwRg9UfZ3lm6Hf0YOwhqR3Ig1KETdcbKnsU
	 slxY+dAlSILSGh1mjXntdEpFrNvxybHkb6Z3twMpxgQtyT1GXtijmokeF8suAi9BTe
	 Oevdx7zIA8RZXAPOsZM9j+k9zxd6O+R/UJP9x5kE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Rosencutter <rosencutter@gmail.com>,
	Lovekesh Solanki <lovekeshsolanki00@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.18 154/403] Input: synaptics - add LEN205b entry to smbus_pnp_ids for ThinkPad T490
Date: Fri,  9 Oct 2026 16:08:35 +0200
Message-ID: <20261009140955.674322707@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lovekesh Solanki <lovekeshsolanki00@gmail.com>

commit a961417c5ae77bbb728a23d9577ecd8f4d8a4b5a upstream.

Lenovo ThinkPad T490 has a Synaptics Touchpad that supports SMBus/RMI4
mode, but is not listed in smbus_pnp_ids table.

Add LEN205b to smbus_pnp_ids[] passlist.

Reported-by: John Rosencutter <rosencutter@gmail.com>
Closes: https://lore.kernel.org/all/CAOGuaRh025eKcBf9P8UrvtXNp68vQ0HVF2EbNMp-kpdaC1HNpA@mail.gmail.com/
Signed-off-by: Lovekesh Solanki <lovekeshsolanki00@gmail.com>
Link: https://patch.msgid.link/20260920200730.1836756-1-lovekeshsolanki00@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/mouse/synaptics.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -191,6 +191,7 @@ static const char * const smbus_pnp_ids[
 	"LEN2054", /* E480 */
 	"LEN2055", /* E580 */
 	"LEN2058", /* E490 */
+	"LEN205b", /* T490 */
 	"LEN2068", /* T14 Gen 1 */
 	"SYN1221", /* TUXEDO InfinityBook Pro 14 v5 */
 	"SYN3003", /* HP EliteBook 850 G1 */


