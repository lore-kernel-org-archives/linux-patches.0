Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061620;
	b=Z4qL2Toh/iutu91/90I2I8vMN2XNot/ZUnUkfH/IEr81TVoHIjT3cM2ZTXdHbpF8AIz+
	 7tawj66BRBsw+TOmQeEIBNnsiUVM3SqXANHoDwoF/hq0XzKCTvxzEN4lctF6jluKHpyoP
	 bsfB7Re5r4v9s8s//3Q4o37fDXsWl3qgfww9SF/A2XXTEvsUR6fyJSNOrHLm9YGpYPDxD
	 dMNU13HhOua8QcsC4oYCYtKmY4ITfRV3lzQ/Hsnn17gkO2A75t9iQUyonhg4FiUAegAM1
	 JVP5GqllqQfGi+h5611GgGSq7Ax28D/4ApkVrONXuR45OIAlBIc4MrvxB1jIi6iWf9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061620;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PSVoh+zCkURq1GsNRJklYer+RyXcIEpdYDdsDdUVOvM=;
	b=QpB+kdGieYo1XMiRY5WP6Za0glGqkb7QgBItWD2Pxn7GYIoad5YEgAtVLmPEoQNcqU7P
	 S9gniz/fNip79FPp46I9YN6jXTXOSgehSt8A12XfbjbdFB/qb1qBX8vjtqYpIk6hp+F5w
	 bgrap0ec2uilQRptBYzgWtboEOe4HRt63r3D/6tFH/8jd/QuEM7Qv/2hRtu0n593E/1A3
	 vbJevIkZNDlxNYswY4JrBT4e9ty0ntjmFRbX4N4FuHi09Gsz7BcCoA+nFA2JDqlne02kX
	 tbX+u4Mf6WdVpQibIa6+8gm/b+4udsNL2PTqqYTSbo2rmZbXflT/LKNKNfLucvLcgow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sFo87S75;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AF00606A326;
	Sat,  7 Nov 2026 14:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sFo87S75
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A75441F0089F;
	Sat,  7 Nov 2026 14:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061619;
	bh=PSVoh+zCkURq1GsNRJklYer+RyXcIEpdYDdsDdUVOvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sFo87S75LQJVsK20O/ToNGhpUWrcMcVXmywstzt3fKMC05CR5nKfWY0pU2dt29NQ0
	 7IRyoPgmkOEeqZaFWTDnhS9X93+NqigiM5df88I02tFAv4DBS3NCwChIQaY1QT4IzQ
	 pjMxl3knYA+W7Qlg+U/QKMtGgy5oh5EAhZ14zYYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0688/1536] xfs: compute the correct fdblocks/frextents for repair when theyre negative
Date: Sat,  7 Nov 2026 08:45:04 -0500
Message-ID: <20261107135016.814559681@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit f98d007017acf0eaec2e116ff9c0ece735f61bb3 upstream.

LOLLM observed that if either fdblocks or frextents are negative, we'll
set the CORRUPT flag and exit immediately.  This doesn't work for a
repair because we still have to walk the filesystem metadata to compute
the correct summary counters so that we can install the new values.
Currently we just write zeroes into the summary counters, which isn't
right.

Cc: stable@vger.kernel.org # v6.9
Fixes: 4ed080cd7cb077 ("xfs: repair summary counters")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/fscounters.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -533,7 +533,10 @@ xchk_fscounters(
 			return -EDEADLOCK;
 
 		xchk_set_corrupt(sc);
-		return 0;
+
+		/* Need to compute all the fields in fsc for a repair */
+		if (!xchk_could_repair(sc))
+			return 0;
 	}
 
 	/* See if icount is obviously wrong. */


