Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4F23184524;
	Sun,  1 Sep 2024 16:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209376; cv=none; b=OkIWKOU+HBJRYtDrPPSPmUomZTP3diQREqOQmhoAJ4wFCSTznAFg/qca6hNwoD/UxcFcVGo03nGYAVwQF5F/fMls5m9OFhLCobTwOOyWzWNAAKrsHOAgXTRIgD3GmhTqIOmRDidigBdgY5fnsFCnlHDfXhASStkjdNc0ibo1sno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209376; c=relaxed/simple;
	bh=2P+bz1W2eMqOK64jzrpAULpIOseXSwwoM7j8Qlqa+0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q92Dn/GI9CIqdKBhPM0h7hKX9VqY9UighTPYRFnr7//4uHpcBkfgKQzJXBZMfPv8LtI3bQ5ZQcEqR/Fh7Ameid/hrpFnfolofEQSPf1pstqEzsLLOHpAgcYdiWGhA+etnk68EE0QqcO4G8jWM/ZrTdKILiA1qKDrR7Sa1zHqNhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oYrof1xw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oYrof1xw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35A20C4CEC3;
	Sun,  1 Sep 2024 16:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209376;
	bh=2P+bz1W2eMqOK64jzrpAULpIOseXSwwoM7j8Qlqa+0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oYrof1xw5/J4ts/l7vMYWeiQVZ31La7iT97+Wp1tmKrmCo56m7X1cFB3f5b3Mu3bI
	 iBG+va4UCou5yvM8OUcM0716zoFKe0aoRv5BOucFYFX0WSOUABYA6Gqsas32oVAdo+
	 xpB1SuaItRh8Rjqju+wZxf+3kB7XCI0MYqOhpsTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 017/151] s390/cio: rename bitmap_size() -> idset_bitmap_size()
Date: Sun,  1 Sep 2024 18:16:17 +0200
Message-ID: <20240901160814.749613350@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


