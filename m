Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210919;
	b=xEv4/CRqifMrmxGHPq1wGXwon/gLuBz1mYBwg6yvS4GNl36bd6ccbvZzraEeZPrsWreJ
	 rcOAfiHXTJaWqejNIHJWBU2WWEuKBMk4BKgVjSmIMKyoxYtXi/AOg369E9VMXVQqg3H3+
	 seAygbQcN3gbRrZ2aiyAm6vUx6aNZhfrv6J9SFE/iUNbgGXpew0MdF3kGMPj6cbb4NvUD
	 Dc0rH0kwAcYED1R+X69HBJibKP47KEc3JnS5NCvQCvlD+DAnWXQnSs/9CxnkCRyH7Kewk
	 nRUiEV3twemNyEVMqMBtb8J5H2dbid8cS9OP7K3w0tn1ub2vh0bg2vq/y2VLmhgelgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210919;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V7jrPY39IIvrbK6AoyTMmKykH4olpuiybqEZ9uPzUr8=;
	b=hkpE15yW9HtxIgSNNgsOF2NAzdEndxpzitvaweMXrmtWTB5I15TLhq6vl7f7B3qVaJLV
	 jZUdBXs5g6es+EX/9RUUO3L0a+tsSFPOY0ZZkHChnC1rpbanx7lH9uT53SiFdbTQlcV/w
	 KABgkuF/RCCsjzbTOI2izDDL9SO9oWFqu6xHKM6FPLkWWXd1Un5D1A9LHybpUcEwylH12
	 bxcJ0928WzNbw+s4SFtAfkUIYF2Ebqj/XrHxH3GQmv22jjLb1En1RbSEv0dyyaqSoHbPZ
	 X4nPtOs0+7sZfwFO7xsH92HVBdqVDez0DbliTcYPAz/RS0D3lo8B32OYY9Jk9uXES+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1sKu5nNt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 835B4606A31A;
	Wed, 28 Oct 2026 18:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1sKu5nNt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 879541F01825;
	Wed, 28 Oct 2026 18:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210919;
	bh=V7jrPY39IIvrbK6AoyTMmKykH4olpuiybqEZ9uPzUr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1sKu5nNtgvkY2Gs6HRqmup61Q9VusERepLlzotp3yKkKjA9VY9XoiZlNBCOjEpdAg
	 S06Guyld0axrMsXMOiEPZLI54RkaoqlK5Or7FUslAZqcadK6tOVHy5XoQXAFw3o+tM
	 IYhY7wuWaqeSmgabLe2mDIKhCUt5gOaZApUGUqsg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Rosencutter <rosencutter@gmail.com>,
	Lovekesh Solanki <lovekeshsolanki00@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.15 195/571] Input: synaptics - add LEN205b entry to smbus_pnp_ids for ThinkPad T490
Date: Wed, 28 Oct 2026 17:55:42 +0100
Message-ID: <20261028170012.636410505@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -188,6 +188,7 @@ static const char * const smbus_pnp_ids[
 	"LEN2054", /* E480 */
 	"LEN2055", /* E580 */
 	"LEN2058", /* E490 */
+	"LEN205b", /* T490 */
 	"LEN2068", /* T14 Gen 1 */
 	"SYN1221", /* TUXEDO InfinityBook Pro 14 v5 */
 	"SYN3003", /* HP EliteBook 850 G1 */


