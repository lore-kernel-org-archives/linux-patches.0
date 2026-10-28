Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212501;
	b=Gyq6MYx5MC+K+vKCjScLOO4pgCQQb4X7RcVyxcLe9UyWiQgu15mnhGh3KTjAc8kwkRMs
	 07Yqd+fzTq7y/NhVa1brPQT9cBEWJs2sxPHi03RT4LD4UaxMKXkehuACHdwSgsQnKNis2
	 mIthZ1gd4UFEHZLzPnoOHCzEf8XSOf055Yas1NyhyxVRIbCKjnjTdp3rbfwTCpBszMSek
	 AKyl+l9fRubEDsKf7AkrtPN0HwQ1z4G8UV9Ce9S4Gn8d8j2Zr4mQwLJdJ4tJtsNsQjcZ1
	 QhnJ030oDIZAGgI3ml+knOkbpMgve0bbtJ4pIEXbpveHnnoptquDyNUVjmBYcTAIuKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212501;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mYdUH2TFDv55bM/XOu89tpQ3PcoaUdPKRfMBPKwh+Jg=;
	b=DN4JaXiY0kP/50phnpUFeFxBenpy4Pw6lUGoab8tlDnG2IJzyyIzwn76ClH21DQHZDq+
	 CJqd8epScDoxMiC5P8/jOzBO6Yr9aea7m1NvITZFmhSntbeKZTs3X6D/yDlQGz5Hmo4J8
	 Xo1NUx/Xdn7rIgzPTovu7M/EVtNsAX/XNJsau1WihnsOK8VqZsQZuPf11XLXbO6tJP7gr
	 Qhr6G/NDwYf/e5xHTNNvjkWT6u3UYzE+yXR4NRZYYU+biD5VyMq7DYlW/1xPMpVxklsy+
	 /OeTfjuVgAPtnHhcztbFHaI0qjMjDhwWx+OQkH1amw/ffgdLveKuQcwt18fVOGAUyBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d6Pz4Ti9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A29C606A31A;
	Wed, 28 Oct 2026 18:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d6Pz4Ti9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9E2B1F01825;
	Wed, 28 Oct 2026 18:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212501;
	bh=mYdUH2TFDv55bM/XOu89tpQ3PcoaUdPKRfMBPKwh+Jg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d6Pz4Ti9/0GRd1yeVDykFHO0IUgkRouWGTu9CWm+0mFEq2bmFG7dTZBijuNy/jlxR
	 wmfvIWx2Rroc9bgDke4NAisnqGNTKg3kBg3vhNJ6yGveVQv6wmipwALV53Cqs/BAO4
	 VFNRNzN48flAUNxFDbdrOZgPFMEdOUJkiz8Xyx1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Abdurrahman Hussain <abdurrahman@nexthop.ai>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.1 0176/1887] of/overlay: only treat a positive changeset id as registered
Date: Wed, 28 Oct 2026 17:37:52 +0100
Message-ID: <20261028170503.241733157@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


