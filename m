Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 280CD3CE0A4;
	Thu,  1 Oct 2026 11:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790854291; cv=none; b=ZPQ08Flfnvz2LEzCE1PFjdimrXthy9l5B/w82NL4tN4QVyNwG4MvjLu67M1Xlkqz+v4T+xNoPmvNOwoczJJmIUUqBdNOJ2rforbMX9H/CSzX0xMnD9JMv3k19njjjnpRBIgygUbEyCyfRnx3Og13cmoOctKU0DFJ9Kwpr0547gQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790854291; c=relaxed/simple;
	bh=2wK5R8+hD/PRg8mRW75qYom1KH+4181lPhA+A4ytQjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bqnbWOcy62y4xjhmCytrD2eVf801XfLV7VXHsk0izJcD7XdeqsULJ5tax28Rv/pdIrz2rNuWHli7maIF5Nxzu5kz7YsQaEWdVdzNUCXprqtnqOYTUyWlFg+Hx2BZb78+EV5yVMMcXX0nv9ChDcsVLbro28sM/N1ljkbTnH/WPbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oqYTiVki; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oqYTiVki"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E4161F00898;
	Thu,  1 Oct 2026 11:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790854278;
	bh=JLgikANshHFRmUI0qMLZg4S04O8PIkXKfZOHlT3POZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oqYTiVkiHvUvwKRUm6GN5p4d6V87Lpa++kcKLgyuQFvTGkgbFlKApRYvZwC6o2rOx
	 ZH6FDYBDvgGhF5pXbzDk44ivre7t0076+jeJykJoc26Bpn1FubEP86l0DIbIi3MHT4
	 IoKN7ygyLmBZJgZplLCZz/yrjnsgsafEN6JYU4Xqc2ZpMNAVCw1AOVC3atle74KRGX
	 sFBiY+3d8LBj/lI3SmLBdi0JEA1gC6rS1QChodxNhm3VIYHbx1QL7arSzCdnKlPVac
	 9kch7JuGUh5g6PuZo8vDjxvgI4KYSFmwz1wO+SMbesdIzZbryre4QpQuf+tGX4yDSB
	 7FUowKMgAKXdw==
From: Sasha Levin <sashal@kernel.org>
To: gregkh@linuxfoundation.org
Cc: Sasha Levin <sashal@kernel.org>,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	kuba@kernel.org
Subject: Re: [PATCH 6.12 864/877] rose: release netdev ref and destroy orphaned incoming sockets
Date: Thu,  1 Oct 2026 07:31:13 -0400
Message-ID: <20261001112559.321b2b92ff8b4ce3@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <CAFAa3YBUKBAD4cHHO5PdMauxLJ46V2_9SU0U=FtnZjgKP-o1Nw@mail.gmail.com>
References: <20260930152414.738996857@linuxfoundation.org> <20260930152433.381204859@linuxfoundation.org> <CAFAa3YBUKBAD4cHHO5PdMauxLJ46V2_9SU0U=FtnZjgKP-o1Nw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, Oct 01, 2026 at 11:42:03AM +0200, Bernard Pidoux wrote:
> - hold 864 back until the fix is available. Note that 868/877 ("rose:
> don't free fd-owned sockets when reaping in the heartbeat") changes
> the same reaping code, so dropping 864 alone may not be
> straightforward.

Dropped with pre-reqs, thanks!

-- 
Thanks,
Sasha
