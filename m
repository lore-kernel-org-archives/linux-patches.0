Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210755;
	b=Y0qrWHkj338VPucoPljFx3f1yG+aFmfXK2X3e1MkarDAZ9ozMrysNWPcXWLWUd3QPneX
	 wz0nWPZ5qqinwAPSQZmlrVnJSSs0qj0w/Y/G7kUbqQcBQ/P9QEP3nT9RDVna2EeZOABFk
	 oxuuPS5plMYIwLHGJjCXDSHBN4Idt8799pPqCM7+NtdzMcKnefLuR4jbHh5u2odSMoprz
	 Qwcw1T1+UMRW3gV/lVmOCvZDHY0OqjSU8Vypkn/7hs41LY+GgW+YQOh5jSTPl6nA2XaRW
	 qzLGtDpUNerXlhni4VkNVrrVX403z09K1MUAIGsqcuP5A8SHpbh+5wHGsbKXxpbDBQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210755;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/Hghs0pmWxMbw/DbICiw3cnd/x4rKghjl2ururrKbZo=;
	b=AhqbFp+py3+KiGsSwKne17QPB+DwOf4txw0CBulgRoSthzbDHrN1h72k1Y7dpJ6Pf2O/
	 Nw84wVJ6gwNXDymfUj59B5VnM95sVCh5yFeT3pdQbZ2x25MJh/DmzYH7BHItC6Q4NLNmC
	 OWvKyYAPRkdjml6qN6h6QszP5XD85PVRtxLactmUbC7VTWtjTEFOrZhJlf3p46kFOQQSU
	 JNKkqD0ViCm4kOzyXvrf6e41ZAoNaygbhDbpqnJxX66a+xJhTZD4xTAKlPzm6KxqHG54U
	 di4CzF8uh49VHI5+5audALmJMGzM2BK7gDwFIuvUyv2JRkkdhmsO12NP7oqYyl/lUQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="uV/1pn2A";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1AC8606A31D;
	Wed, 28 Oct 2026 18:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uV/1pn2A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 206CB1F01825;
	Wed, 28 Oct 2026 18:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210754;
	bh=/Hghs0pmWxMbw/DbICiw3cnd/x4rKghjl2ururrKbZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uV/1pn2Az5P9yPk8Kv3Q6tdJlKIwayjyqUP6DwkdhYHkjNsM6EFu7doJLaQo8LmCP
	 RNMnv4Nnzx7kUBG3eCq0uziToGq2HzrbNnvAE1fVu1fz20ySR9nBdauMmcQEjjwa6I
	 wfMHdba77DWrWgitiWob3m6X6K1dKMjpFxe+YZ7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Abdurrahman Hussain <abdurrahman@nexthop.ai>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 5.15 138/571] of/overlay: only treat a positive changeset id as registered
Date: Wed, 28 Oct 2026 17:54:45 +0100
Message-ID: <20261028170011.291447416@linuxfoundation.org>
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

From: Abdurrahman Hussain <abdurrahman@nexthop.ai>

commit 44081d708b5b885487bac792db78324b7b4c267d upstream.

of_overlay_fdt_apply() stores the idr_alloc() return value in
ovcs->id before checking it. On failure the stored id is negative,
free_overlay_changeset()'s "if (ovcs->id)" check passes, idr_remove()
is called with a negative id and list_del() runs on ovcs->ovcs_list,
which is not initialized until after the id allocation. An allocation
failure at that point dereferences NULL.

Make free_overlay_changeset() treat only a strict-positive id as
registered. The rest of the function already copes with a
partially-initialized ovcs, so the error path stays a plain
goto err_free_ovcs.

Fixes: 61b4de4e0b38 ("of: overlay: minor restructuring")
Cc: stable@vger.kernel.org
Suggested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Assisted-by: Claude:claude-fable-5 [Claude Code]
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Abdurrahman Hussain <abdurrahman@nexthop.ai>
Link: https://patch.msgid.link/20260831-nh-of-alias-overlay-v7-5-02754604805a@nexthop.ai
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/overlay.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/of/overlay.c
+++ b/drivers/of/overlay.c
@@ -840,7 +840,8 @@ static void free_overlay_changeset(struc
 	if (ovcs->cset.entries.next)
 		of_changeset_destroy(&ovcs->cset);
 
-	if (ovcs->id) {
+	/* a failed idr_alloc() leaves its negative error in ovcs->id */
+	if (ovcs->id > 0) {
 		idr_remove(&ovcs_idr, ovcs->id);
 		list_del(&ovcs->ovcs_list);
 		ovcs->id = 0;


