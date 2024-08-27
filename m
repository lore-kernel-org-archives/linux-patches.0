Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77FF217C96;
	Tue, 27 Aug 2024 15:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771774; cv=none; b=SseNdDj03I+wFaquF+rgSpMNetc3frmU5z60Aq9lgFxP4z60wH65ZS3MlOD2IeANFT5o7WLzuyq9hb/dyFQbCp1WQVAvATiUlVcoHFi8v5xkZaOPV3JZRxMkE+kEfec5FhBxbkFAMF/50TXxiIjR7tJWKri11f05sSClPTTyIjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771774; c=relaxed/simple;
	bh=J3JqaYUmku/fDUUtbys62J4TkEIa3WvzuhcGUMCUHKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g/lZhl31S8blEq2cXyI9GZjD1AUSnTbZP9RY90hOA5gHzuQa94AkIz2Sv/gi8hTWuMb9/F4d9ELQUoQUPQqPqzxQmyH3jO/lR4v/pXZZl3h1bgC+3QqBzwjHYiXLUt2olmNnFJr/UW4npiYaXyr66O+vwq6DvLizK+Lvd4M4n2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D8vQgcHn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D8vQgcHn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB8A5C4AF50;
	Tue, 27 Aug 2024 15:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771774;
	bh=J3JqaYUmku/fDUUtbys62J4TkEIa3WvzuhcGUMCUHKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D8vQgcHn3PNqXrNjhkX8m2Jaup5cDvtCzMEggZ00py+INR0mszLpt6bON9dRP/Fts
	 z6l4iDeSsUgwm+W6CE3J5nep86xqaAQmSwHaNVSgNfuomJ9FcdEVAL2q2F8fbj5hER
	 ZP0Rnmr1+jWlCNjVKkn8T0qyDUumxrT+pdtgOCzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 017/321] s390/cio: rename bitmap_size() -> idset_bitmap_size()
Date: Tue, 27 Aug 2024 16:35:25 +0200
Message-ID: <20240827143838.863519171@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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
 	unsigned long bitmap[];
 };
 
-static inline unsigned long bitmap_size(int num_ssid, int num_id)
+static inline unsigned long idset_bitmap_size(int num_ssid, int num_id)
 {
 	return BITS_TO_LONGS(num_ssid * num_id) * sizeof(unsigned long);
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


