Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38D8E27F725;
	Wed, 23 Apr 2025 15:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421861; cv=none; b=RrTmjJDcqIVurnOcIkrw8sx/IC66fggZtmWIyhtlh0MPs61IWLvZdqM7iCVwH2qzXLGucd5SkKrVmqioX+5dUvze+aWPEMp+v5wN7HmwfVOWsPPuDYZnCIVtt/fBMF3rLXjjlG2flAz51dCYZ+6axlhbjkB+CAfOFQfbJwZmQoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421861; c=relaxed/simple;
	bh=ac4ddB3RxZV49HmUZrvFOKF+wXfLwg02IWWgGX0VzsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Av28Tmt5lAdRzp//ufMWpyhihxXxU/N6mvenDpVSxugkxYLNjz04Bq854aNbahnha5/PmhRa8ZrKW7MsFW3NkxUwwiaIoyFYUJE8HH+qStEj+tBPa5QBYbW0wjaxOOfleCsJ9KDREBGb2XaxSW/3I0q9HoK9JmdH6srOo4ZhHzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TlVxKB1a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TlVxKB1a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D816C4CEE3;
	Wed, 23 Apr 2025 15:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421860;
	bh=ac4ddB3RxZV49HmUZrvFOKF+wXfLwg02IWWgGX0VzsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TlVxKB1aW+gYmd2M1iRYSESSp1Nd1HHzfRKCD9kEdTUKu1SZzppjh4yWlFZFqHo6l
	 2vKYybLYCu7Dsn4C0+sA0xZ+kB8LajfcPcjRdJnA/OAGA9MHoS9uNoXV5TTvBdmsO4
	 2e2KRyYk/e/6iQQk9x+nq6qTu2loXNnL2EXZ+XIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Eric Auger <eric.auger@redhat.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.14 224/241] arm64/sysreg: Add register fields for HFGITR2_EL2
Date: Wed, 23 Apr 2025 16:44:48 +0200
Message-ID: <20250423142629.704582700@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anshuman Khandual <anshuman.khandual@arm.com>

commit 9401476f17747586a8bfb29abfdf5ade7a8bceef upstream.

This adds register fields for HFGITR2_EL2 as per the definitions based
on DDI0601 2024-12.

Cc: Will Deacon <will@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Link: https://lore.kernel.org/r/20250203050828.1049370-5-anshuman.khandual@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/tools/sysreg |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2872,6 +2872,12 @@ Field	1	AMEVCNTR00_EL0
 Field	0	AMCNTEN0
 EndSysreg
 
+Sysreg	HFGITR2_EL2	3	4	3	1	7
+Res0	63:2
+Field	1	nDCCIVAPS
+Field	0	TSBCSYNC
+EndSysreg
+
 Sysreg	ZCR_EL2	3	4	1	2	0
 Fields	ZCR_ELx
 EndSysreg


