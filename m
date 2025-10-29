Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11EB932F777;
	Wed, 29 Oct 2025 11:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761737973; cv=none; b=NphbFO2xpLzRioLndofvlQ9ZKwVVtpUuNc/gPM+51Ix5OZYibTGE7TEYXVMu6HKb+MiCyf7eivITH/yPOagwvnw84KWlriVLXinYCWJdK3lO8ueFcnN5pVKSBCHJdlRSfqcj/4xeTat3uJBPkgoOr8IY2ZH55h0LFX2eIaxbYy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761737973; c=relaxed/simple;
	bh=6C8y/bWWAanzKHpDtdX8MPRYbKkBqoosD3tQWkhEzOM=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:Cc:To:From:
	 References:In-Reply-To; b=TQOUbPzSw5aHyh2Z/qmtnqAYVvPVZFUleEpB4H6Zv58bmVGfu98nC46qYuUTOTsNyh+fT+TWegI4RDCy2FBN7ClCrMqUHqUVoP5rtvbMwVCchUhYMwe9To7DIqxiHtdV/WVfKx2EPrrU79/y3p0qrwAgyUyORxMuO19RMIGYiB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XtLvVY4N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XtLvVY4N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CB2BC4CEF7;
	Wed, 29 Oct 2025 11:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761737972;
	bh=6C8y/bWWAanzKHpDtdX8MPRYbKkBqoosD3tQWkhEzOM=;
	h=Date:Subject:Cc:To:From:References:In-Reply-To:From;
	b=XtLvVY4NrO4Snv5JasMT2k+z/PdaOcXUjcoUmWrTxmdrDpWofIKPDwwtynyjWQgzX
	 bR8hF8vD7adXlDXCaVX4wljrP55Bu4etdRZOf6+F6Z4vHtnYfK+xKO2F/pL6vCjfm6
	 Nsl/vVxIFzZ/2Id1k3l7NSyRTO3ufWqbKc0heVyDBqZGcPDvYQ9ZCRcCr84H6+pm1J
	 SnUbsH6IXUzPw8hBIMiK3y359DL+7gtgqzqu0rlzyYtrLtDwmJ3K6pbtyRbIt1ihJi
	 hE8P3MxWRC6mehCXd9GFzzGDY09+7nJW+Z+mNWpIf/yJwUq6OaKClKEUllYvDQvb1l
	 3IyLmon3hZR6Q==
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 29 Oct 2025 12:39:27 +0100
Message-Id: <DDURZLGB2VRJ.28Y4AP92FNFPS@kernel.org>
Subject: Re: [PATCH] rust: devres: fix private intra-doc link
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "Rafael J. Wysocki"
 <rafael@kernel.org>, "Alex Gaynor" <alex.gaynor@gmail.com>, "Boqun Feng"
 <boqun.feng@gmail.com>, "Gary Guo" <gary@garyguo.net>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, "Benno Lossin"
 <lossin@kernel.org>, "Andreas Hindborg" <a.hindborg@kernel.org>, "Alice
 Ryhl" <aliceryhl@google.com>, "Trevor Gross" <tmgross@umich.edu>,
 <rust-for-linux@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <patches@lists.linux.dev>, <stable@vger.kernel.org>
To: "Miguel Ojeda" <ojeda@kernel.org>
From: "Danilo Krummrich" <dakr@kernel.org>
References: <20251029071406.324511-1-ojeda@kernel.org>
In-Reply-To: <20251029071406.324511-1-ojeda@kernel.org>

On Wed Oct 29, 2025 at 8:14 AM CET, Miguel Ojeda wrote:
> The future move of pin-init to `syn` uncovers the following private
> intra-doc link:

Given that, do you want to take this one through your tree? If so, please d=
o,
otherwise please let me know.

Acked-by: Danilo Krummrich <dakr@kernel.org>
