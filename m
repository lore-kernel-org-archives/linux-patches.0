Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8566541735B;
	Tue, 21 Jul 2026 19:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663939; cv=none; b=fsnVxhQ9u4XHGTOrQBPE3/mqumeH7fJLseGW/6MF1bl8TRxPuSmK4p6QtQKJBuF69sp+VoQJcDXFIixXukeEUnPDjuaTiUiRocsTGq7539ylZjq37pzM/0FrYC93ExvMLJiNW3NBc4JgEJd9e548kB9m8VLmelvmnItwWDMaNRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663939; c=relaxed/simple;
	bh=eLFRrrtTDhnztXfn7L/sspUNbxeusvM/RIasfu1eIUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b+wF/pTXvaw2/e4gI/yUIOk0KtbBvhmKZKFJppcsfmMCZ0RWAM2qzj9nsiDaGXoAdoDYZhupboJbeb8zVPFADhIbb9Jglck7INhKlzx1bYh2H16p5YVBePsgbSbxRSH3fCVrCGJFnV34S8tt61yRNef1F+2Dyt+uUUqrxXTxx9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ms4uKNvK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ms4uKNvK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C0241F000E9;
	Tue, 21 Jul 2026 19:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663937;
	bh=/glHQDmZkKDXKMdhqYLo9P5Eu+Wala6WKIWRCdG7Y4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ms4uKNvKBAf6jaVsPil2NyzroG/U624JZ5JT9qr6uTd3QrAubxJMy6NbvAj73l54Q
	 oc8Waz1gHnrBBI5B6LHdk8FyyLX3QLADVaNff4ZrKVp9hWD0s9DpPyop/q42GyjBp1
	 hhFMbejSl38DC5lcPQE7hcj1WkOp7h6wpBFBibLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.12 1010/1276] dm-integrity: dont increment hash_offset twice
Date: Tue, 21 Jul 2026 17:24:13 +0200
Message-ID: <20260721152508.608277226@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit edf025f083854f80032b73a1aad69a3c90db236f upstream.

hash_offset is already incremented in the loop "for (i = 0; i < to_copy;
i++, ts--)". Do not increment it again.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-4.6
Fixes: 84597a44a9d8 ("dm-integrity: dm integrity: add optional discard support")
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-integrity.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -1470,9 +1470,6 @@ thorough_test:
 			*metadata_offset = 0;
 		}
 
-		if (unlikely(!is_power_of_2(ic->tag_size)))
-			hash_offset = (hash_offset + to_copy) % ic->tag_size;
-
 		total_size -= to_copy;
 	} while (unlikely(total_size));
 


