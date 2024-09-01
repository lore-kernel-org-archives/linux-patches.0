Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 994491C68C;
	Sun,  1 Sep 2024 16:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208702; cv=none; b=LpJoKlQTgYNn3mTq5tQTmTT/cwUqUMUr+OZNveappOqaPZwjsHN7mshHoB1LjzBjc1Flz3Ow0jimcqJFejAbH6rU4I7zhdid85X4efZQ0JVSrK5hZXaDjpeAWJ4fwABaQPCdUGXh8eF0rCEisv8pn3pUILX08p1Y74+/rmnXbyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208702; c=relaxed/simple;
	bh=kQNWj+nEG4XKAqqkb+IbNfF0/UuKVJjniw5QrTBJG3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ImZulABCqjvGjRzxhOWU4RbMpbDsuqAl27La1K3HTQCexNOCLryXN8d2Zg+ET9BjQh2ocsH3fXiYKeq6mr1axLOgY4wneBlZf8so3qSzOP3ceNbk2/uAh+SEVbaRMDg9iqeXoXYamyY9HNr6o5xcBhuuXGBmo2xM1g21WK9tr74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DHQRqnjD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DHQRqnjD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08A63C4CEC3;
	Sun,  1 Sep 2024 16:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208702;
	bh=kQNWj+nEG4XKAqqkb+IbNfF0/UuKVJjniw5QrTBJG3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DHQRqnjDPQ2ZKEVXxEDWkIO7lZQ/+92apBILsMzXmHP9p5lUYuXJbZjCzFKoR3p00
	 pW0Y+Pl4JL11W7fd6/VnZpqLRJ95Q4Y0TEg6UEqia9MMsE6oBXMiSgzQ3rBtoVGuIC
	 CDP1sb9sPyQ1NsL1grOIZ2u05YnQfWiQUwbTMCZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 014/134] s390/cio: rename bitmap_size() -> idset_bitmap_size()
Date: Sun,  1 Sep 2024 18:16:00 +0200
Message-ID: <20240901160810.649315498@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Lobakin <aleksander.lobakin@intel.com>

commit c1023f5634b9bfcbfff0dc200245309e3cde9b54 upstream.

bitmap_size() is a pretty generic name and one may want to use it for
a generic bitmap API function. At the same time, its logic is not
"generic", i.e. it's not just `nbits -> size of bitmap in bytes`
converter as it would be expected from its name.
Add the prefix 'idset_' used throughout the file where the function
resides.

Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Acked-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/cio/idset.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/s390/cio/idset.c
+++ b/drivers/s390/cio/idset.c
@@ -16,7 +16,7 @@ struct idset {
 	unsigned long bitmap[0];
 };
 
-static inline unsigned long bitmap_size(int num_ssid, int num_id)
+static inline unsigned long idset_bitmap_size(int num_ssid, int num_id)
 {
 	return bitmap_size(size_mul(num_ssid, num_id));
 }
@@ -25,11 +25,12 @@ static struct idset *idset_new(int num_s
 {
 	struct idset *set;
 
-	set = vmalloc(sizeof(struct idset) + bitmap_size(num_ssid, num_id));
+	set = vmalloc(sizeof(struct idset) +
+		      idset_bitmap_size(num_ssid, num_id));
 	if (set) {
 		set->num_ssid = num_ssid;
 		set->num_id = num_id;
-		memset(set->bitmap, 0, bitmap_size(num_ssid, num_id));
+		memset(set->bitmap, 0, idset_bitmap_size(num_ssid, num_id));
 	}
 	return set;
 }
@@ -41,7 +42,8 @@ void idset_free(struct idset *set)
 
 void idset_fill(struct idset *set)
 {
-	memset(set->bitmap, 0xff, bitmap_size(set->num_ssid, set->num_id));
+	memset(set->bitmap, 0xff,
+	       idset_bitmap_size(set->num_ssid, set->num_id));
 }
 
 static inline void idset_add(struct idset *set, int ssid, int id)


